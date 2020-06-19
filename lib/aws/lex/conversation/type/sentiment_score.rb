module Aws
  module Lex
    class Conversation
      module Type
        class SentimentScore
          include Base

          required :positive, from: :Positive
          required :negative, from: :Negative
          required :neutral, from: :Neutral
          required :mixed, from: :Mixed

          class << self
            def parse_string(str)
              parts = str
                .gsub(/[\{\}]/, '') # remove '{' or '}' chars
                .split(',')         # break into components
                .map { |c| c.gsub(/\s/, '').split(':') }

              params = parts.each_with_object({}) do |part, hash|
                label = part.first
                value = part.last.to_f
                hash[label] = value
              end

              shrink_wrap(params)
            end
          end
        end
      end
    end
  end
end
