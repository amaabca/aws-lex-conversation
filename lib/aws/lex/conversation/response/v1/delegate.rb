# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        module V1
          class Delegate < Base
            attr_accessor :slots, :kendra_query_request_payload, :kendra_query_filter_string

            def initialize(opts = {})
              super
              self.slots = opts[:slots]
              self.kendra_query_request_payload = opts[:kendra_query_request_payload]
              self.kendra_query_filter_string = opts[:kendra_query_filter_string]
            end

            def dialog_action
              {
                type: 'Delegate',
                slots: slots,
                kendraQueryRequestPayload: kendra_query_request_payload,
                kendraQueryFilterString: kendra_query_filter_string
              }.compact
            end
          end
        end
      end
    end
  end
end
