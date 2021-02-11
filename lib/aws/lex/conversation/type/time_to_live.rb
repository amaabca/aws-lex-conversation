# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class TimeToLive
          include Base

          required :time_to_live_in_seconds
          required :turns_to_live

          coerce(
            time_to_live_in_seconds: integer!,
            turns_to_live: integer!
          )

          alias_method :seconds, :time_to_live_in_seconds
          alias_method :seconds=, :time_to_live_in_seconds=
          alias_method :turns, :turns_to_live
          alias_method :turns=, :turns_to_live=
        end
      end
    end
  end
end
