require 'json'
#require_relative '../cli_flag'
#require_relative 'analyze'
#require_relative 'extract'
#require_relative 'hash_database'
require_relative 'colors'

module HEITT

  def self.tree_line(items, prefix = "", parent_is_last=true, is_root=true)
    result = ""
    items.each_with_index do |node, i|
      is_last_item = (i == items.length - 1)

      line = if is_root
        "#{node[:text]}\n"
      else
        "#{HEITT.colorize(prefix, :blue)}#{HEITT.colorize((is_last_item ? '└── ' : '├── '), :blue)}#{node[:text]}\n"
      end

      child_prefix = if is_root
        ""
      else
        "#{HEITT.colorize(prefix, :bold, :blue)}#{HEITT.colorize((is_last_item ? "    " : "│   "), :bold, :blue)}"
        #prefix + (is_last_item ? "   " : "│  ")
      end
      result += line

      # line + 
      result += tree_line(node[:children], child_prefix, is_last_item, false) if node[:children].any?
      
      if is_last_item && !is_root and !node[:children].any?
        result += "#{HEITT.colorize(prefix, :bold, :blue)}  \n"
      end
    end
    result
  end


  def self.tree_format(ident_result, verbose: false)
    result = ""
    #unless ident_result.found
    #since everything now passes through extraction even precleaned hashes, ident_result.found will never be false.

    # return ""
    #  result += "UNKNOWN FORMAT - #{ident_result.count} HASH \n"
    #  tree_items = [
        #{text: "Characteristics: Mixed charset, unusual pattern", children: []},
        #{text: "Possible: Custom hash, session token or false positive", children: [] },
    #    {text: "Hash: ", children: [
    #      {text: ident_result.hash, children: []}
    #    ]}
    #  ]
    #  result += tree_line(tree_items, "", true, true)

    #else
      candidate_nodes = []
      ident_result.algorithms.each_with_index do |hash_algo, idx|
      
        property_children = [
          {text: "Hashcat Mode: #{hash_algo.hashcat}", children: []},
          {text: "John Format: #{hash_algo.john}", children: []},
        ]
      
      if verbose
        # Handle description
        property_children << {text: "Description: #{hash_algo.description}", children: []} if hash_algo.description && !hash_algo.description.empty?

        # Handle characteristics
        property_children << {text: "Characteristics: #{hash_algo.characteristics}", children: []} if hash_algo.characteristics && !hash_algo.characteristics.empty?
      
        # Handle notes
        if hash_algo.notes && !hash_algo.notes.empty?
          notes_children = hash_algo.notes.map { |note| {text: note, children: []}}
          property_children << {text: "Notes:", children: notes_children}
       end  
      end

       confidence = hash_algo.confidence.nil? ? "" :  " — CONFIDENCE: #{hash_algo.confidence&.upcase}"
       candidate_nodes << {
        text: "#{HEITT.colorize("[", :bold, :blue)}#{HEITT.colorize("CANDIDATE #{idx+1}: ", :bold, :cyan)}#{HEITT.colorize("#{hash_algo.name}#{confidence}", :bold, :green)}#{HEITT.colorize("]", :bold, :blue)}",
        children: property_children
       }  
      #result += tree_line(tree_items, "", false, false)
      end
      result += tree_line(candidate_nodes, "", false, false)
    #end
    result
  end

  def self.tree_group_format(group_result, verbose: false)
    #result = "GROUPED HASHES\n"
    result = ""
    #root = {text: "[GROUPED HASHES]", children: []}
    root = {text: "#{HEITT.colorize("\n\n[", :bold, :blue)}#{HEITT.colorize("CLUSTERED HASHES", :green)}#{HEITT.colorize("]", :bold, :blue)}", children: []}
  
    # First sections: List all hash clusters with their hashes
    group_result.groups.each do |group|
      cluster_node = {
        text: HEITT.colorize("HASH CLUSTER #{(group[:cluster_id])}", :magenta, :bold), 
        children: group[:hashes].map{|h| {text: h, children: []}}
      }
      root[:children] << cluster_node
    end
    result += tree_line([root])


    #Second section: Details for each cluster
    group_result.groups.each do |group|

      result += "#{HEITT.colorize("\n\n[", :bold, :blue)}#{HEITT.colorize("HASH CLUSTER #{group[:cluster_id]}", :white, :bold)}#{HEITT.colorize("]\n", :bold, :blue)}"#, children: []}
    
      result += tree_format(group[:identified_result], verbose: verbose)

    end
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