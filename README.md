# Aws::Lex::Conversation

Have you played around with [AWS Lex](https://aws.amazon.com/lex/) and quickly realized you were duplicating code to read and generate the [Lex Lambda input event and response format](https://docs.aws.amazon.com/lex/latest/dg/lambda-input-response-format.html)?

`Aws::Lex::Conversation` provides a mechanism to define the flow of a Lex conversation with a user easily!

## Installation

### Lex V1

Version 3.x is the last major version of this gem that will support Lex V1.

Add this line to your application's Gemfile:

```ruby
gem 'aws-lex-conversation', '~> 3.0'
```

And then execute:

```bash
bundle install
```

### Lex V2

Version 4.x and higher support Lex V2.

Add this line to your application's Gemfile:

```ruby
gem 'aws-lex-conversation', '>= 4.0'
```

And then execute:

```bash
bundle install
```

## Usage

At a high level, you must create a new instance of `Aws::Lex::Conversation`.

Generally the conversation instance will be initialized inside your Lambda handler method as follows:

```ruby
def my_lambda_handler(event:, context:)
  conversation = Aws::Lex::Conversation.new(event: event, context: context)

  # define a chain of your own Handler classes
  conversation.handlers = [
    {
      handler: Aws::Lex::Conversation::Handler::Delegate,
      options: {
        respond_on: ->(conversation) { conversation.current_intent.name == 'MyIntent' }
      }
    }
  ]

  # return a response object to indicate Lex's next action
  conversation.respond
end
```

Any custom behaviour in your flow is achieved by defining a Handler class. Handler classes must provide the following:

1. Inherit from `Aws::Lex::Conversation::Handler::Base`.
2. Define a `will_respond?(conversation)` method that returns a boolean value.
3. Define a `response(conversation)` method to return final response to Lex. This method is called if `will_respond?` returns `true`.

The handlers defined on an `Aws::Lex::Conversation` instance will be called one-by-one in the order defined.

The first handler that returns `true` for the `will_respond?` method will provide the final Lex response action.

### Custom Handler Example

```ruby
class SayHello < Aws::Lex::Conversation::Handler::Base
  def will_respond?(conversation)
    conversation.lex.invocation_source.dialog_code_hook? && # callback is for DialogCodeHook (i.e. validation)
    conversation.lex.current_intent.name == 'SayHello' &&   # Lex has routed to the 'SayHello' intent
    conversation.slots[:name].filled?                       # our expected slot value is set
  end

  def response(conversation)
    name = conversation.slots[:name].value

    # NOTE: you can use the Type::* classes if you wish. The final output
    # will be normalized to a value that complies with the Lex response format.
    #
    # You can also specify raw values for the response:
    #
    # conversation.close(
    #   fulfillment_state: 'Fulfilled',
    #   message: { content: "Hello, #{name}!", contentType: 'PlainText' }
    # )
    #
    conversation.close(
      fulfillment_state: Aws::Lex::Conversation::Type::FulfillmentState.new('Fulfilled'),
      messages: [
        Aws::Lex::Conversation::Type::Message.new(
          content: "Hello, #{name}!",
          content_type: Aws::Lex::Conversation::Type::Message::ContentType.new('PlainText')
        )
      ]
    )
  end
end
```

## Built-In Handlers

### `Aws::Lex::Conversation::Handler::Echo`

This handler simply returns a close response with a message that matches the `inputTranscript` property of the input event.

| Option           | Required | Description                                                  | Default Value                       |
|------------------|----------|--------------------------------------------------------------|-------------------------------------|
| respond_on       | No       | A callable that provides the condition for `will_handle?`.   | `->(c) { false }`                   |
| fulfillment_state| No       | The `fulfillmentState` value (i.e. `Fulfilled` or `Failed`). | `Fulfilled`                         |
| content_type     | No       | The `contentType` for the message response.                  | `PlainText`                         |
| content          | No       | The response message content.                                | `conversation.lex.input_transcript` |

i.e.

```ruby
conversation = Aws::Lex::Conversation.new(event: event, context: context)
conversation.handlers = [
  {
    handler: Aws::Lex::Conversation::Handler::Echo,
    options: {
      respond_on: ->(c) { true },
      fulfillment_state: 'Failed',
      content_type: 'SSML',
      content: '<speak>Sorry<break> an error occurred.</speak>'
    }
  }
]
conversation.respond # => { dialogAction: { type: 'Close' } ... }
```

### `Aws::Lex::Conversation::Handler::Delegate`

This handler returns a `Delegate` response to the Lex bot (i.e. "do the next bot action").

| Option           | Required | Description                                                  | Default Value                       |
|------------------|----------|--------------------------------------------------------------|-------------------------------------|
| respond_on       | No       | A callable that provides the condition for `will_handle?`.   | `->(c) { false }`                   |

i.e.

```ruby
conversation = Aws::Lex::Conversation.new(event: event, context: context)
conversation.handlers = [
  {
    handler: Aws::Lex::Conversation::Handler::Delegate,
    options: {
      respond_on: ->(c) { true }
    }
  }
]
conversation.respond # => { dialogAction: { type: 'Delegate' } }
```

### `Aws::Lex::Conversation::Handler::SlotResolution`

This handler will set all slot values equal to their top resolution in the input event. The handler then calls the next handler in the chain for a response.

**NOTE:** This handler must not be the final handler in the chain. An exception of type `Aws::Lex::Conversation::Exception::MissingHandler` will be raised if there is no successor handler.

| Option           | Required | Description                                                  | Default Value                       |
|------------------|----------|--------------------------------------------------------------|-------------------------------------|
| respond_on       | No       | A callable that provides the condition for `will_handle?`.   | `->(c) { true }`                   |

i.e.

```ruby
conversation = Aws::Lex::Conversation.new(event: event, context: context)
conversation.handlers = [
  {
    handler: Aws::Lex::Conversation::Handler::SlotResolution
  },
  {
    handler: Aws::Lex::Conversation::Handler::Delegate,
    options: {
      respond_on: ->(c) { true }
    }
  }
]
conversation.respond # => { dialogAction: { type: 'Delegate' } }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amaabca/aws-lex-conversation. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/amaabca/aws-lex-conversation/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Aws::Lex::Conversation project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/amaabca/aws-lex-conversation/blob/master/CODE_OF_CONDUCT.md).
