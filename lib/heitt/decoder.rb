require 'base64'
module HEITT
  module Decoder
    ENCODED_B64 = '[A-Za-z0-9+\/]'
    BASE_HEXBYTE = '[[:xdigit:]]'

    def self.binary?(string)
      return true if string.encoding == Encoding::ASCII_8BIT && !string.valid_encoding?
      return true if string.include?("\x00")
      sample = string.bytes.first(4096)
      non_printable = sample.count { |b| b < 32 || b > 126}
      (non_printable.to_f / sample.size) > 0.30
    end

    def self.likely_base64?(string)
      string.match(/\A(?:#{ENCODED_B64}{4})*(?:#{ENCODED_B64}{2}==|#{ENCODED_B64}{3}=)?\z/)
    end

    def self.likely_hex?(string)
      string.match(/\A#{BASE_HEXBYTE}+\z/) && string.length.even?
    end

    def self.decode_layer(string)
      return [:base64, Base64.decode64(string)] if likely_base64?(string)
      return [:hex, [string].pack("H*")] if likely_hex?(string)
      nil
    end


    def self.peel(string, peel_limit: 12)
      steps = []
      current = string.gsub(/\s+/, '')

      peel_limit.times do
        result = decode_layer(current)
        break unless result
        method, decoded = result
        decoded = decoded.gsub(/\s+/, '')
        break if binary?(decoded)

        steps << { method: method, result: decoded }
        current = decoded
      end
      { final: current, steps: steps }
    end
  end
end
          