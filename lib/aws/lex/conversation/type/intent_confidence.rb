# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class IntentConfidence
          include Base

          required :event

          def ambiguous?(threshold: standard_deviation)
            candidates(threshold: threshold).size > 1
          end

          def unambiguous?(threshold: standard_deviation)
            !ambiguous?(threshold: threshold)
          end

          # NOTE: by default this method looks for candidates
          # with a confidence score within one standard deviation
          # of the current intent. Confidence scores may not be
          # normally distributed, so it's very possible that this
          # method will return abnormal results for skewed sample sets.
          #
          # If you want a consistent threshold for the condition, pass
          # a static `threshold` parameter.
          def candidates(threshold: standard_deviation)
            intents = event.intents.select do |intent|
              diff = event.current_intent
                .nlu_confidence
                .to_f
                .-(intent.nlu_confidence.to_f)
                .abs

              diff <= threshold
            end

            # sort descending
            intents.sort do |a, b|
              b.nlu_confidence.to_f <=> a.nlu_confidence.to_f
            end
          end

          def mean
            @mean ||= calculate_mean
          end

          def similar_alternates(threshold: standard_deviation)
            # remove the first element (current intent) from consideration
            candidates(threshold: threshold)[1..-1]
          end

          def standard_deviation
            @standard_deviation ||= calculate_standard_deviation
          end

          private

          def calculate_mean
            sum = event.intents.sum { |i| i.nlu_confidence.to_f }
            sum / event.intents.size
          end

          def calculate_standard_deviation
            normalized = event.intents.map do |intent|
              (intent.nlu_confidence.to_f - mean) ** 2
            end
            normalized_mean = normalized.sum / normalized.size
            Math.sqrt(normalized_mean)
          end
        end
      end
    end
  end
end
