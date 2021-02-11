# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Context
          include Base

          required :time_to_live
          required :name
          required :parameters

          coerce(
            time_to_live: TimeToLive,
            parameters: symbolize_hash!
          )
        end
      end
    end
  end
end
