# frozen_string_literal: true

FactoryBot.define do
  factory :context, class: OpenStruct do
    get_remaining_time_in_millis { rand(2000) }
    function_name { 'test' }
    function_version { '$LATEST' }
    invoked_function_arn { 'arn:aws:lambda:us-east-1:123456789000:function:TestFunction' }
    memory_limit_in_mb { 256 }
    aws_request_id { SecureRandom.uuid }
    log_group_name { '/aws/lambda/TestFunction' }
    log_stream_name { SecureRandom.uuid }
    deadline_ms { (Time.now.to_i * 1000) + get_remaining_time_in_millis }
    identity { nil }
    client_context { nil }
  end
end
