require 'json'
require 'set'
require 'strscan'
require 'colorize'
require_relative 'heitt/database'
require_relative 'heitt/version'

module HEITT
  module Color
    def self.colorize(text, color, *styles)
      return text unless STDOUT.isatty #&& !(defined?(Flags) && Flags.no_color)

      colored = text.colorize(color)
      styles.each do |style|
        colored = colored.send(style)
      end
      colored
    end
  end
  #private_constant :Color
  
  
  module Grouper

    def self.group(results)
      clusters = {}

      clusters = results.group_by {|r| r[:candidates].first[:name]}
      groups = clusters.each_with_index.map do |(name, group), index|
        hashes = group.map {|r| r[:hash]}
        {
          cluster_id: index+1,
          hashes: hashes,
          candidates: group.first[:candidates],
          count: hashes.size
        }
      end
      groups
    end
  end



  module Analyzer
    def self.analyze(text, database: HEITT::DATABASE)
      keyword_counts = keyword_counts(text.downcase, database: database)
      algorithm_scores(keyword_counts, database: database)
    end

    def self.extract_prefix(text, offset)
      line_start = text.rindex("\n", offset) || 0
      text[line_start...offset]
    end

    def self.high_entropy?(text, min_ent)
      entropy(text) >= min_ent
    end
      

    def self.score_candidates(modes, delim_prefix, context_scores)
      prefix_matched_mode = nil
      #context based scoring
      matches = modes.map do |mode|
        score_data = context_scores[mode[:name]]
        score = score_data || 0

        if prefix_match?(mode, delim_prefix)
          #boost score as confidence is high if prefix matched
          prefix_matched_mode = mode[:name]
          score += 20
        end
        {
          name: mode[:name],
          hashcat: mode[:hashcat],
          john: mode[:john],
          description: mode[:description],
          extended: mode[:extended],
          score: score
        }
      end 
      return [] if matches.empty?

      #calculate confidence
      scores_hash = matches.map {|m| [m[:name], m[:score]]}.to_h 
      
      confidences = assign_confidence(scores_hash, prefix_matched_mode)
      matches.map{|m| m.merge(confidence: confidences[m[:name]])}.sort_by {|m| -m[:score]}
    end


    private
    def self.get_modes(entry)
      entry[:modes] || entry[:algorithms] || entry[:hashes] || 
      entry[:candidates] || entry[:types] || entry[:hashtypes]
    end

    #this  code is an inspiration of "https://github.com/chrisjchandler/entropy/blob/main/entropy.go"
    def self.entropy(text)
      frequency = Hash.new(0)
      text.each_char { |ch| frequency[ch] += 1 }

      #calculate the total number of characters
      total = text.length.to_f
      #caluclate entropy
      entropy = 0.0
      frequency.each_value do |count|
        probability = count.to_f / total
        entropy += probability * Math.log2(probability)
      end
      #negate the sum as entropy is positive
      -entropy
    end
    
    def self.keyword_counts(content_lower, database: HEITT::DATABASE)
      keywords = database.flat_map do |entry|
        modes = get_modes(entry)
        next [] unless modes
        modes.flat_map {|mode| mode[:context] || []}
      end.uniq.map(&:downcase)

      counts = {}
      keywords.each do |kw|
        count = content_lower.scan(/\b#{Regexp.escape(kw)}\b/).size
        counts[kw] = count if count > 0
      end
      counts
    end


    def self.algorithm_scores(keyword_counts, database: HEITT::DATABASE)
      scores = {}
      return scores if keyword_counts.nil?

      database.each do |entry|
        modes = get_modes(entry)
        next unless modes
        modes.each do |mode|
          contexts = mode[:context] || []
          next if contexts.empty?
          total = contexts.sum {|kw| keyword_counts[kw.downcase] || 0}
          scores[mode[:name]] = total if total > 0
        end
      end
      scores
    end


    def self.prefix_match?(mode, delim_prefix)
      prefixes = mode[:prefixes] || []
      return false if prefixes.empty?

      delimiters =  "= : "
      raw_prefix = delim_prefix.strip.split(/[#{Regexp.escape(delimiters)}]/).last&.strip&.downcase
      prefixes.map(&:downcase).include?(raw_prefix)
    end


    def self.assign_confidence(scores_hash,  prefix_matched_mode=nil)
      all_scores = scores_hash.values

      return {} if all_scores.empty?

      avg_score = all_scores.sum.to_f / all_scores.size
     
      scores_hash.transform_values do |score|
        if score == 0
          "regex-match"
        else
          mode_name = scores_hash.key(score)
          is_prefix_mode = (prefix_matched_mode == mode_name)
          deviation = (score - avg_score) / avg_score

          case deviation
          when 2.0..Float::INFINITY
            "high"
          when 0.5..2.0
            is_prefix_mode ? "high" : "medium-high"
          else
            is_prefix_mode ? "medium-high" : "medium-low"
          end
        end 
      end
    end
  end
  #private_constant :Analyzer



  module Scanner

    def self.scan(input, database: HEITT::DATABASE, min_entropy: 3.5)
      text = File.exist?(input) ? File.read(input) : input
      context_scores = HEITT::Analyzer.analyze(text, database: database)
      found = {}#[]
      seen = {}
     

      database.each do |entry|
        regex = get_regex(entry)
        modes = get_modes(entry)
        next unless regex && modes && !modes.empty?
        pattern = regex.is_a?(Regexp) ? regex : Regexp.new(regex)
        scanner = StringScanner.new(text)      
        
        while scanner.scan_until(pattern)
          matched = scanner.matched
          next unless matched.length < 8 || HEITT::Analyzer.high_entropy?(matched, min_entropy)
          offset = scanner.pos - matched.length
          delim_prefix = HEITT::Analyzer.extract_prefix(text, offset)

          candidates = HEITT::Analyzer.score_candidates(modes, delim_prefix, context_scores)
          score = candidates.first[:score]

          found[matched] ||= {hash: matched, candidates: []}
          found[matched][:candidates].concat(candidates)
          end
        end

          found.each_value do |result|
           result[:candidates] = result[:candidates]
            .group_by {|c| c[:name]}
            .map {|name, dupes| dupes.max_by {|c| c[:score]}}
            .sort_by {|c| -c[:score]}

            # Re-assign confidence based on final merged scores
            scores_hash = result[:candidates].map {|c| [c[:name], c[:score]]}.to_h
            confidences = Analyzer.assign_confidence(scores_hash)
            result[:candidates] = result[:candidates].map {|c| c.merge(confidence: confidences[c[:name]])}
      end
      found.values
    end

    private
    
    def self.get_regex(entry)
      entry[:extract_regex] || entry[:regex] || entry[:pattern] || entry[:regexp]
    end

    def self.get_modes(entry)
      entry[:modes] || entry[:algorithms] || entry[:hashes] || 
      entry[:candidates] || entry[:types] || entry[:hashtypes]
    end
  end


  module Formatter


    def self.tree(groups, verbose: false, extended: false, show_regex_match: false)
      result = ""

      #Filter out groups with extended candidates as true
      visible_groups = groups.select do |group|
        has_non_extended = group[:candidates].any? {|c| !c[:extended] || extended}
        has_non_regex = group[:candidates].any? {|c| c[:confidence] != "regex-match" || show_regex_match}
        has_non_extended && has_non_regex
      end
      #Renumber after filtering
      renumbered_groups= visible_groups.each_with_index.map { |group, index| group.merge(cluster_id: index + 1) }

      root = {
        text: "#{HEITT::Color.colorize("\n\n[", :bold, :blue)}#{HEITT::Color.colorize("CLUSTERED HASHES", :green)}#{HEITT::Color.colorize("]", :bold, :blue)}", 
        children: renumbered_groups.map do |group|
          {
            text: HEITT::Color.colorize("HASH CLUSTER #{group[:cluster_id]}", :magenta, :bold),
            children: group[:hashes].map{|h| {text: h, children: []}}
          }
        end
      }

      result += render_tree([root])

      renumbered_groups.each do |group|
        result += "#{HEITT::Color.colorize("\n\n[", :bold, :blue)}#{HEITT::Color.colorize("HASH CLUSTER #{group[:cluster_id]}", :white, :bold)}#{HEITT::Color.colorize("]\n", :bold, :blue)}"#, children: []}
        candidate_nodes = (group[:candidates]).each_with_index.map do |candidate, idx|
          next if candidate.nil?
          next if candidate[:name].nil?
          next if candidate[:extended] && !extended
          next if candidate[:confidence] == "regex-match" && !show_regex_match
          confidence = candidate[:confidence] ? " — CONFIDENCE: #{candidate[:confidence].upcase}" : ""

          children = [
            {text: "Hashcat Mode: #{candidate[:hashcat] || "--"}", children: []},
            {text: "John Format: #{candidate[:john] || "--"}", children: []}
          ]

          if verbose
            if candidate[:description] && !candidate[:description].empty?
              children << {text: "Description: #{candidate[:description]}", children: []}
            end

            if candidate[:notes] && !candidate[:notes].empty?
              children << {text: "Notes:", children: candidate[:notes].map {|note| {text: note, children: []}}}
            end
          end
          {
            text: "#{HEITT::Color.colorize("[", :bold, :blue)}#{HEITT::Color.colorize("CANDIDATE #{idx + 1}: ", :bold, :cyan)}#{HEITT::Color.colorize("#{candidate[:name]}#{confidence}", :bold, :cyan)}#{HEITT::Color.colorize("]", :bold, :blue)}",
            children: children
          }
        end.compact
        result += render_tree(candidate_nodes, "", false, false) unless candidate_nodes.nil? || candidate_nodes.empty?
      end
      result
    end

    def self.json(groups, extended: false, show_regex_match: false)
      visible_groups = groups.select do |group|
        has_non_extended = group[:candidates].any? {|c| c[:extended] || extended}
        has_non_regex =  group[:candidates].any? {|c| c[:confidence] != "regex-match" || show_regex_match}
        has_non_extended && has_non_regex
      end
      #Renumber after filtering
      renumbered_groups = visible_groups.each_with_index.map { |group, index| group.merge(cluster_id: index+1)}

      JSON.pretty_generate(
        renumbered_groups.map do |group|
          visible_candidates = group[:candidates].select do |c|
            (!c[:extended] || extended)  && (c[:confidence] != "regex-match" || show_regex_match)
          end
          {
           cluster_id: group[:cluster_id],
           count: group[:count],
            hashes: group[:hashes],
            candidates: visible_candidates.map do |candidate|
              {
                name: candidate[:name],
                hashcat: candidate[:hashcat],
                john: candidate[:john],
                confidence: candidate[:confidence],
                description: candidate[:description]
              }
            end
          }
        end
      )
    end

    private
    def self.render_tree(items, prefix = "", parent_is_last=true, is_root=true)
      result = ""

      items.each_with_index do |node, i|
        is_last_item = (i == items.length - 1)

        line = if is_root
          "#{node[:text]}\n"
        else
          "#{HEITT::Color.colorize(prefix, :blue)}#{HEITT::Color.colorize((is_last_item ? '└── ' : '├── '), :blue)}#{node[:text]}\n"
        end

        child_prefix = if is_root
          ""
        else
          "#{HEITT::Color.colorize(prefix, :bold, :blue)}#{HEITT::Color.colorize((is_last_item ? "    " : "│   "), :bold, :blue)}"
        end
        result += line 
        result += render_tree(node[:children], child_prefix, is_last_item, false) if node[:children].any?
      
        if is_last_item && !is_root and !node[:children].any?
          result += "#{HEITT::Color.colorize(prefix, :bold, :blue)}  \n"
        end
      end
      result
    end
  end
end
       