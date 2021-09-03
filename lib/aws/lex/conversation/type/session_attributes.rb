# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class SessionAttributes < Hash
          include Base

          optional :checkpoints

          def checkpoints
            @checkpoints ||= JSON.parse(
              Base64.urlsafe_decode64(fetch(:checkpoints) { Base64.urlsafe_encode64([].to_json, padding: false) })
            ).map do |checkpoint|
              Checkpoint.shrink_wrap(checkpoint)
            end
          end

          def to_lex
            merge(
              checkpoints: Base64.urlsafe_encode64(checkpoints.map(&:to_lex).to_json, padding: false)
            ).to_h
          end
        end
      end
    end
  end
end
