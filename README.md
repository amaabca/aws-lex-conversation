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
    #   messages: [{ content: "Hello, #{name}!", contentType: 'PlainText' }]
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

## Advanced Concepts

This library provides a few constructs to help manage complex interactions:

### Data Stash

`Aws::Lex::Conversation` instances implement a `stash` method that can be used to store temporary data within a single invocation.

A conversation's stashed data will not be persisted between multiple invocations of your lambda function.

The conversation stash is a great spot to store deserialized data from the session, or invocation-specific state that needs to be shared between handler classes.

This example illustrates how the stash can be used to store deserialized data from the session:

```ruby
# given we have JSON-serialized data in as a persisted session value
conversation.session[:user_data] = '{"name":"Jane","id":1234,"email":"test@example.com"}'
# we can deserialize the data into a Hash that we store in the conversation stash
conversation.stash[:user] = JSON.parse(conversation.session[:user_data])
# later on we can reference our stashed data (within the same invocation)
conversation.stash[:user] # => {"name"=>"Jane", "id"=>1234, "email"=>"test@example.com"}
```

### Checkpoints

A conversation may transition between many different topics as the interaction progresses. This type of state transition can be easily handled with checkpoints.

When a checkpoint is created, all intent and slot data is encoded and stored into a `checkpoints` session value. This data persist between invocations, and is not removed until the checkpoint is restored.

You can create a checkpoint as follows:

```ruby
# we're ready to fulfill the OrderFlowers intent, but we want to elicit another intent first
conversation.checkpoint!(
  label: 'order_flowers',
  dialog_action_type: 'Close' # defaults to 'Delegate' if not specified
)
conversation.elicit_intent(
  messages: [
    {
      content: 'Thanks! Before I place your order, is there anything else I can help with?',
      contentType: 'PlainText'
    }
  ]
)
```

You can restore the checkpoint in one of two ways:

```ruby
# in a future invocation, we can fetch an instance of the checkpoint and easily
# restore the conversation to the previous state
checkpoint = conversation.checkpoint(label: 'order_flowers')
checkpoint.restore!(
  fulfillment_state: 'Fulfilled',
  messages: [
    {
      content: 'Okay, your flowers have been ordered! Thanks!',
      contentType: 'PlainText'
    }
  ]
) # => our response object to Lex is returned
```

It's also possible to restore state from a checkpoint and utilize the conversation's handler chain:

```ruby
class AnotherIntent < Aws::Lex::Conversation::Handler::Base
  def will_respond?(conversation)
    conversation.intent_name == 'AnotherIntent' &&
    conversation.checkpoint?(label: 'order_flowers')
  end

  def response(conversation)
    checkpoint = conversation.checkpoint(label: 'order_flowers')
    # replace the conversation's current resolved intent/slot data with the saved checkpoint data
    conversation.restore_from!(checkpoint)
    # call the next handler in the chain to produce a response
    successor.handle(conversation)
  end
end

class OrderFlowers < Aws::Lex::Conversation::Handler::Base
  def will_respond?(conversation)
    conversation.intent_name == 'OrderFlowers'
  end

  def response(conversation)
    conversation.close(
      fulfillment_state: 'Fulfilled',
      messages: [
        {
          content: 'Okay, your flowers have been ordered! Thanks!',
          contentType: 'PlainText'
        }
      ]
    )
  end
end

conversation = Aws::Lex::Conversation.new(event: event, context: context)
conversation.handlers = [
  { handler: AnotherIntent },
  { handler: OrderFlowers }
]
conversation.respond # => returns a Lex response object
```

## Test Helpers

This library provides convenience methods to make testing easy! You can use the test helpers as follows:

```ruby
# we must explicitly require the test helpers
require 'aws/lex/conversation/spec'

# optional: include the custom matchers if you're using RSpec
RSpec.configure do |config|
  config.include(Aws::Lex::Conversation::Spec)
end

# we can now simulate state in a test somewhere
it 'simulates a conversation' do
  conversation                      # given we have an instance of Aws::Lex::Conversation
    .simulate!                      # simulation modifies the underlying instance
    .transcript('My age is 21')     # optionally set an input transcript
    .intent(name: 'MyCoolIntent')   # route to the intent named "MyCoolIntent"
    .slot(name: 'Age', value: '21') # add a slot named "Age" with a corresponding value

  expect(conversation).to have_transcript('My age is 21')
  expect(conversation).to route_to_intent('MyCoolIntent')
  expect(conversation).to have_slot(name: 'Age', value: '21')
end

# if you'd rather create your own event from scratch
it 'creates an event' do
  simulator = Aws::Lex::Conversation::Simulator.new
  simulator
    .transcript('I am 21 years old.')
    .input_mode('Speech')
    .context(name: 'WelcomeGreetingCompleted')
    .invocation_source('FulfillmentCodeHook')
    .session(username: 'jane.doe')
    .intent(
      name: 'GuessZodiacSign',
      state: 'ReadyForFulfillment',
      slots: {
        age: {
          value: '21'
        }
      }
    )
  event = simulator.event

  expect(event).to have_transcript('I am 21 years old.')
  expect(event).to have_input_mode('Speech')
  expect(event).to have_active_context(name: 'WelcomeGreetingCompleted')
  expect(event).to have_invocation_source('FulfillmentCodeHook')
  expect(event).to route_to_intent('GuessZodiacSign')
  expect(event).to have_slot(name: 'age', value: '21')
  expect(event).to include_session_values(username: 'jane.doe')
end
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
