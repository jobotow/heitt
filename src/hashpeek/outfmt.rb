require 'json'
#require_relative '../cli_flag'
#require_relative 'analyze'
#require_relative 'extract'
#require_relative 'hash_database'
require_relative 'colors'

module HEITT


def self.default_format(ident_result)
  result = ""
  unless indent_result[:found]
    result += HEITT.colorize("\n[ERROR] Unknown hash format", :red, :bold)
  end

  ident_result[:algorithms].each do |hash_algo|
    result += HEITT.colorize("\n#{hash_algo.name}", :red, :bold)
    if hash_algo[:characteristics] != ""
      result += "Characteristic: #{hash_algo[:characteristics]}"
    end
    result += HEITT.colorize("\n    HashCat Mode: ", :bold, :magenta)
    result += HEITT.colorize("#{hash_algo.hashcat}", :bold, :yellow)
    result += HEITT.colorize("\n    John Format: ", :bold, :green)
    result += HEITT.colorize("#{hash_algo.john}\n", :yellow, :bold)
  end
  result 
end

def self.tree_line(items, prefix = "", parent_is_last=true, is_root=true)
  items.each_with_index.map do |node, i|
    is_last_item = (i == items.length - 1)

    line = if is_root
      "#{node[:text]}\n"
    else
      "#{HEITT.colorize(prefix, :bold, :blue)}#{HEITT.colorize((is_last_item ? '└─ ' : '├─ '), :bold, :blue)}#{node[:text]}\n"
    end

    child_prefix = if is_root
      ""
    else
      "#{HEITT.colorize(prefix, :bold, :blue)}#{HEITT.colorize((is_last_item ? "   " : "│  "), :bold, :blue)}"
      #prefix + (is_last_item ? "   " : "│  ")
    end

    line + (node[:children].any? ? tree_line(node[:children], child_prefix, is_last_item, false) : "")
  end.join
end
=begin
def self.tree_line(items, prefix="", is_last=true, is_root=true)
  items.each_with_index.map do |node, i|
    line = is_root ? "#{node[:text]}\n" : "#{prefix}#{i == items.length - 1 ? '└─ ' : '├─ '}#{node[:text]}\n"
    new_prefix = is_root ? "" : "#{prefix}#{(i == items.length - 1 ? "   " : "│  ")}"
    line + (node[:children].any? ? tree_line(node[:children], new_prefix, false, false) : "")
  end.join
end

=begin
def self.tree_line(items)
  result = ""
  stack = items.reverse.map{|item|  [item, 0, []]}

  until stack.empty?
    item, depth, mask = stack.pop

    prefix = ""
    mask.each { |has_pipe| prefix += has_pipe ? "│ " : "   "}
    prefix += depth > 0 ? (stack.any? { |_, d, _| d == depth } ? "└─ " : "├─ ") : ""
    result += "#{prefix}#{item[:text]}\n"

    if item[:children] && !item[:children].empty?
      children = item[:children]
      children.reverse.each_with_index do |child, ri|
        i = children.length - 1 - ri
        is_last = (i == children.length - 1)
        stack.push([child, depth +1, mask+[!is_last]])
      end
    end
  end
  result 
end
=end


def self.tree_format(ident_result, show_header=true)
  result = ""
  unless ident_result[:found]
    result += "UNKNOWN FORMAT - 1 HASH (12.76)\n"
    tree_items = [
      {text: "Characteristics: Mixed charset, unusual pattern", children: []},
      {text: "Possible: Custom hash, session token or false positive", children: [] },
      {text: "Hash: ", children: [
        {text: ident_result[:hash], children: []}
      ]}
    ]
    result += tree_line(tree_items, 1)

  else
    number = 0
    ident_result[:algorithms].each do |hash_algo|
      number += 1
      if show_header
        result += HEITT.colorize("\n[", :bold, :blue)
        result += HEITT.colorize("CANDIDATE #{number}: ", :bold, :cyan)
        result += HEITT.colorize("#{hash_algo.name}", :bold, :green)
        result += " - 70% CONFIDENCE"
        result += HEITT.colorize("]\n", :bold, :blue)
        #puts "\n[CANDIDATE #{number}: #{hash_algo[:name]} - 70% CONFIDENCE]\n"
        #result << "\n[CANDIDATE #{number}: #{hash_algo.name} - 70% CONFIDENCE]\n"
        #result << tree_line({text: "Characteristics: #{hash_algo.characteristics}", children: []}, "", true, false)
        #result << tree_line({text: "Common Sources: #{hash_algo.common_sources}", children: []}, "", true, false)
        #result << tree_line({text: "Hashcat Mode: #{hash_algo.hashcat}", children: []}, "", true, false)
        #result << tree_line({text: "John Format: #{hash_algo.john}", children: []}, "", true, false)
      end
      
      tree_items = [
        {text: "Characteristics: #{hash_algo.characteristics}", children: []},
        {text: "Common Sources: #{hash_algo.common_sources}", children: []},
        {text: "Hashcat Mode: #{hash_algo.hashcat}", children: []},
        {text: "John Format: #{hash_algo.john}", children: []}
      ]
      
      # Handle notes
      if hash_algo.notes && !hash_algo.notes.empty?
        notes_children = hash_algo.notes.map { |note| {text: note, children: []}}
        tree_items << {text: "Notes:", children: notes_children}
      end
      
      # Handle limitations
      if hash_algo.limitations && !hash_algo.limitations.empty?
        limit_children = hash_algo.limitations.map { |lim| {text: lim, children: []}}
        tree_items << {text: "Limitations:", children: limit_children}
      end

        result += tree_line(tree_items, "", false, false)
    end
  end
  result 
end

def self.tree_group_format(group_result)
  #result = "GROUPED HASHES\n"
  result = ""
  root = {text: "[GROUPED HASHES]", children: []}
  group_count = 0
  
  # First sections: List all hash clusters with their hashes
  group_result[:groups].each_with_index do |group, i|
    group_count += i
    puts "GROUPD_COUNT: #{group_result.total_hashes}"
    #result += tree_line([
      cluster_node = {text: HEITT.colorize("HASH CLUSTER #{(group_count+1).to_s}", :bold, :magenta), children: group[:hashes].map{|h| {text: h, children: []}}}#])
      root[:children] << cluster_node

    #hash_items = group[:hashes].map { |h|  {text: h, children: []}}
    #is_last_group = (i == group_result[:groups].length - 1) 
    #result += tree_line(hash_items, "", false, false)
  end
  result += tree_line([root])

  #Second section: Details for each cluster
  cluster_count = 0
  group_result[:groups].each do |group|
    cluster_count += 1
    result += HEITT.colorize("\n\nHASH CLUSTER #{cluster_count}", :bold, :white)
    result += HEITT.colorize(": #{group.count} OF #{group_result[:total_hashes]} HASHES ARE\n", :color => "#FF6600")
    
    #Call tree_format without header because cluster header already exists
    result += tree_format(group[:identified_result], true)
  end
  result 
end


def self.json_group_format(group_result)
  groups_array = []
  group_result[:groups].each do |group|
    groups_array << {
        algorithm: group[:algorithm],
        hashes: group[:hashes]
    }
  end
  JSON.pretty_generate({groups: groups_array})
end


def self.json_format(ident_result)
  unless ident_result[:found]
    json_err = {
        status: "unknown",
        characteristics: "mixed charset, unusual pattern",
        description: "custom hash, session token or false positive",
        hash: ident_result[:hash]
    }
    return JSON.pretty_generate(json_err)
  end
  
  processed_algos = []
  ident_result[:algorithms].each do |algo|
    algo_obj = algo.dup

    algo_obj[:hashcat] = algo_obj[:hashcat] == "--" ? nil : algo_obj[:hashcat].to_i
    algo_obj[:john] = algo_obj[:john] == "--" ? nil : algo_obj[:john]
    algo_obj
  end

  JSON.pretty_generate({ident_result[:hash] => processed_algos})
end


def self.json_err_out(err_out)
  json_err = {
    status: err_out[:status],
    message: err_out[:message],
    line: err_out[:line],
    content: err_out[:content]
  }
  JSON.pretty_generate(json_err)
end
end


#uSage
=begin
items = [
  {text: "root1", children: [
    {text: "child1", children: []},
    {text: "child2", children: []}#children: [
      #{text: "granchild1", children: [] }
   # ]}
  ]},
  {text: "root2", children: []}
]
=end
=begin

items = [
  {
    text: "HASH CLUSTER 1",
    children: [
      {text: "abcde", children: []},
      {text: "def", children: []}
     ]
  },
  {
    text: "HASH CLUSTER 2",
    children: [
      {text: "xyz", children: [{text: "nested", children: []}]},
      {text: "uvw", children: []}
    ]
  }
]

puts HEITT.tree_line(items) 
=end