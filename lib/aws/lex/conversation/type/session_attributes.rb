# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class SessionAttributes < Hash
          include Base

          optional :checkpoints

          def checkpoints
            @checkpoints ||= begin # rubocop:disable Style/RedundantBegin
              JSON.parse(Base64.decode64(fetch(:checkpoints) { Base64.encode64([].to_json) })).map do |checkpoint|
                Checkpoint.shrink_wrap(checkpoint)
              end
            end
          end

          def to_lex
            merge(
              checkpoints: Base64.encode64(checkpoints.map(&:to_lex).to_json)
            )
          end
        end
      end
    end
  end
end
