require 'json'
require_relative 'utils'

module HEITT
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