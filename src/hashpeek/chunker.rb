#this file is made to divide a given file or stream of hashes into chunks
import strutils, strformat, os

#with time, improvements have for it to support stream of hash inputs
def process_in_chunks(filename, max_line)
  chunk_count = 0
  total_hashes = 0
  chunk = []

  if File.exists?(filename)
    File.open(filename, 'r') do |file|
      file.each_line do |line|
        total_hashes += 1
        chunk << line
        
        if chunk.length >= max_line
          chunk_count += 1
          puts "[INFO] Found #{total_hashes} hashes in chunk #{chunk_count}"
          puts chunk
          #after using that specific chunk, remember to free memory
          chunk.clear
          total_hashes = 0
        end
      end
    end
    #reset total hashes count
    total_hashes = 0

    #process last chunk
    if chunk.length > 0 
      total_hashes += 1
      chunk_count += 1
      echo "[INFO] Found #{total_hashes} hashes in last chunk #{chunk_count}"
      echo chunk
    end
  end
end
      
     
