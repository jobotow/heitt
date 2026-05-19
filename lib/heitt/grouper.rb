require_relative 'utils'
module HEITT 
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
      HEITT::Logger.debug("Hashes grouped successfully") unless groups.empty? || groups.nil?
      groups
    end
  end 
end