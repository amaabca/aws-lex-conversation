# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Context
          include Base

          required :context_attributes
          required :name
          required :time_to_live

          coerce(
            context_attributes: symbolize_hash!,
            time_to_live: TimeToLive
          )
        end
      end
    end
  end
end
