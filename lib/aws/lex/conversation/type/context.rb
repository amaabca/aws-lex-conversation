# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Context
          include Base

          required :name
          required :time_to_live
          required :context_attributes, default: -> { {} }

          coerce(
            context_attributes: symbolize_hash!,
            time_to_live: TimeToLive
          )
        end
      end
    end
  end
end
