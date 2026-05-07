require 'json'
#require_relative '../cli_flag'
#require_relative 'analyze'
#require_relative 'extract'
#require_relative 'hash_database'
require_relative 'colors'

#more outputs will likely be added: csv, table 

module HEITT

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
    unless ident_result.found
      result += "UNKNOWN FORMAT - 1 HASH (12.76)\n"
      tree_items = [
        #{text: "Characteristics: Mixed charset, unusual pattern", children: []},
        #{text: "Possible: Custom hash, session token or false positive", children: [] },
        {text: "Hash: ", children: [
          {text: ident_result.hash, children: []}
        ]}
      ]
      result += tree_line(tree_items, "", true, true)

    else
      #number = 0
      ident_result.algorithms.each_with_index do |hash_algo, idx|
        #number += 1
        if show_header
          result += HEITT.colorize("\n[", :bold, :blue)
          result += HEITT.colorize("CANDIDATE #{idx+1}: ", :bold, :cyan)
          result += HEITT.colorize("#{hash_algo.name}", :bold, :green)
          #result += " - 70% CONFIDENCE"
          result += HEITT.colorize("]\n", :bold, :blue)
          #puts "\n[CANDIDATE #{number}: #{hash_algo[:name]} - 70% CONFIDENCE]\n"
          #result << "\n[CANDIDATE #{number}: #{hash_algo.name} - 70% CONFIDENCE]\n"
          #result << tree_line({text: "Characteristics: #{hash_algo.characteristics}", children: []}, "", true, false)
          #result << tree_line({text: "Common Sources: #{hash_algo.common_sources}", children: []}, "", true, false)
          #result << tree_line({text: "Hashcat Mode: #{hash_algo.hashcat}", children: []}, "", true, false)
          #result << tree_line({text: "John Format: #{hash_algo.john}", children: []}, "", true, false)
        end
      
        tree_items = [
          {text: "Hashcat Mode: #{hash_algo.hashcat}", children: []},
          {text: "John Format: #{hash_algo.john}", children: []},
        ]

        # Handle description
        tree_items << {text: "Description: #{hash_algo.description}", children: []} if hash_algo.description && !hash_algo.description.empty?

        # Handle characteristics
        tree_items << {text: "Characteristics: #{hash_algo.characteristics}", children: []} if hash_algo.characteristics && !hash_algo.characteristics.empty?
      
        # Handle notes
        if hash_algo.notes && !hash_algo.notes.empty?
          notes_children = hash_algo.notes.map { |note| {text: note, children: []}}
          tree_items << {text: "Notes:", children: notes_children}
       end    
      result += tree_line(tree_items, "", false, false)
      end
    end
    result += "\n\n"
    result
  end

  def self.tree_group_format(group_result)
    #result = "GROUPED HASHES\n"
    result = ""
    root = {text: "[GROUPED HASHES]", children: []}
    group_count = 0
  
    # First sections: List all hash clusters with their hashes
    group_result.groups.each_with_index do |group, i|
      group_count += i
      #result += tree_line([
        cluster_node = {text: HEITT.colorize("HASH CLUSTER #{(group_count+1).to_s}", :bold, :magenta), children: group[:hashes].map{|h| {text: h, children: []}}}#])
        root[:children] << cluster_node

      #hash_items = group[:hashes].map { |h|  {text: h, children: []}}
      #is_last_group = (i == group_result[:groups].length - 1) 
      #result += tree_line(hash_items, "", false, false)
    end
    result += tree_line([root])

    #Second section: Details for each cluster
    group_result.groups.each_with_index do |group, c_idx|
      result += HEITT.colorize("\n\nHASH CLUSTER #{c_idx+1}", :bold, :white)
      result += HEITT.colorize(": #{group[:count]} OF #{group_result.total_hashes} HASHES ARE\n", :color => "#FF6600")
    
      #Call tree_format without header because cluster header already exists
      result += tree_format(group[:identified_result], true)
    end
    #result += "\n\n"
    result 
  end


  def self.json_group_format(group_result)
    groups_array = []
    group_result.groups.each do |group|
      groups_array << {
        hashes: group[:hashes],
        algorithms: group[:identified_result].algorithms.map {|algo|
        {
        name: algo.name,
        hashcat: algo.hashcat == "--" ? nil : algo.hashcat.to_i,
        john: algo.john == "--" ? nil : algo.john,
        description: algo.description,
        characteristics: algo.characteristics,
        notes: algo.notes
        }}
      }
    end
    JSON.pretty_generate({groups: groups_array})
  end


  def self.json_format(ident_result)
    unless ident_result.found
      json_err = {
        status: "unknown",
        #characteristics: "mixed charset, unusual pattern",
        #description: "custom hash, session token or false positive",
        hash: ident_result.hash
      }
      return JSON.pretty_generate(json_err)
    end
  
    processed_algos = []
    #puts "ALGORITHMS: #{ident_result[:algorithms]}"
    ident_result.algorithms.each do |algo|
      #algo_obj = algo.dup
      algo_hash = {
        name: algo.name,
        hashcat: algo.hashcat == "--" ? nil : algo.hashcat.to_i,
        john: algo.john == "--" ? nil : algo.john,
        description: algo.description,
        characteristics: algo.characteristics,
        notes: algo.notes
      }
      processed_algos << algo_hash
    end
    JSON.pretty_generate(ident_result.hash => processed_algos)
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