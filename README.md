# `Aws::Lex::Conversation`

Building a chatbot with [AWS Lex](https://aws.amazon.com/lex/) is really fun! Unfortunately implementing your bot's behaviour with the [Lex/Lambda event protocol](https://docs.aws.amazon.com/lexv2/latest/dg/lambda.html) is less fun.

But don't worry - we've done the hard work for you!

`Aws::Lex::Conversation` makes it simple to build dynamic, conversational chatbots with AWS Lex and AWS Lambda!

## Installation

```ruby
gem 'aws-lex-conversation'
```

And then execute:

```bash
bundle install
```

**Please Note:** This library currently supports [AWS Lex Version 2](https://docs.aws.amazon.com/lexv2/latest/dg/lambda.html). If you're looking for Lex V1 support, lock `aws-lex-conversation` to `~> 3.0` in your `Gemfile`.

## Core Concepts

### The Conversation Instance

Instances of `Aws::Lex::Conversation` wrap the Lex input/output event format and make it easy to manage conversation dialog.

Imagine you have a `ButlerBot` configured with a `ServeBreakfast` intent and `BreakfastFood` slot.

The backing lambda handler for your bot might look something like:

```ruby
require "aws-lex-conversation"

def lambda_handler(event:, context:)
  # The conversation instance validates and wraps the Lex input event
  conversation = Aws::Lex::Conversation.new(event: event, context: context)

  # Return a Close dialog action to our Lex bot to end the conversation
  conversation.close(
    fulfillment_state: "Fulfilled",
    messages: [
      # We can construct response messages using wrapper classes.
      Aws::Lex::Conversation::Type::Message.new(
        content: "Hi - I'm a 🤖!"
      ),
      # Or we can pass a Hash that directly maps to the Lex response format
      {
        content: "Your intent is: #{conversation.intent_name}",
        contentType: "PlainText"
      },
      {
        content: "Here's your #{conversation.slots[:BreakfastFood].value}!",
        contentType: "PlainText"
      }
    ]
  )
end
```

This lambda handler would generate the following dialog:

![ButlerBot Dialog](https://raw.github.com/amaabca/aws-lex-conversation/transcriptions/data/butler_bot.png height=200)

All data from the Lex input event is exposed via the `lex` attribute. By convention, the `lex` attribute directly translates input event attributes from `camelCase` to `snake_case`.

We also provide some helpers to help manage the conversation. For example:

```ruby
# returns true if the lambda function was invoked as a DialogCodeHook
conversation.lex.invocation_source.dialog_code_hook?

# returns true if the InputMode is Speech
conversation.lex.input_mode.speech?

# you can easily set or retrieve a session values
conversation.session[:name] = "Jane"
conversation.session[:name] # => "Jane"

# dealing with slot data is simple
conversation.slots[:BreakfastFood].filled? # returns true if a slot value is present
conversation.slots[:Hometown].blank?       # returns true if a slot value is nil/empty
conversation.slots[:FirstName].value       # => "John"
```

### The Handler Chain

Conversational dialog gets complex quickly! Conversation instances include a handler chain that can help manage this complexity.

Each handler in the chain defines the prerequisites necessary for the handler to generate a response.

You can configure the handler chain as follows:

```ruby
def lambda_handler(event:, context:)
  conversation = Aws::Lex::Conversation.new(event: event, context: context)

  conversation.handlers = [
    # You need to define custom handler classes yourself
    { handler: ServeBreakfast },
    { handler: FallbackIntent },
    # We offer a few "built in" handlers
    {
      handler: Aws::Lex::Conversation::Handler::Delegate,
      options: {
        # If we get this far, always return a Delegate action
        respond_on: ->(_) { true }
      }
    }
  ]

  # The respond method will execute each handler sequentially and return a Lex response
  conversation.respond
end
```

### Writing Your Own Handler

Generally, custom behaviour in your flow is achieved by defining your own handler class. Handler classes must:

1. Inherit from `Aws::Lex::Conversation::Handler::Base`.
2. Define a `will_respond?(conversation)` method that returns a boolean value.
3. Define a `response(conversation)` method to return final response to Lex. This method is called if `will_respond?` returns `true`.

Handlers in the chain are invoked sequentially in the order defined.

The first handler in the chain that returns `true` for the `will_respond?` method will provide the final Lex response action.

Here's an example for the `ServeBreakfast` and `FallbackIntent` handlers above:

```ruby
class ServeBreakfast < Aws::Lex::Conversation::Handler::Base
  def will_respond?(conversation)
    conversation.intent_name == "ServeBreakfast" &&   
    conversation.slots[:BreakfastFood].filled?                      
  end

  def response(conversation)
    food = conversation.slots[:BreakfastFood].value
    emoji = food == "waffle" ? "🧇" : "🥓"

    conversation.close(
      fulfillment_state: "Fulfilled",
      messages: [
        {
          content: "Here's your #{emoji}!",
          contentType: "PlainText"
        }
      ]
    )
  end
end

class FallbackIntent < Aws::Lex::Conversation::Handler::Base
  def will_respond?(conversation)
    conversation.intent_name == "FallbackIntent"
  end

  def response(conversation)
    conversation.close(
      fulfillment_state: 'Failed',
      messages: [
        {
          content: "Sorry - I'm not sure what you said!",
          contentType: "PlainText"
        }
      ]
    )
  end
end
```

### Built-In Handlers

#### `Aws::Lex::Conversation::Handler::Echo`

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

#### `Aws::Lex::Conversation::Handler::Delegate`

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

#### `Aws::Lex::Conversation::Handler::SlotResolution`

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

When a checkpoint is created, all intent and slot data is encoded and stored into a `checkpoints` session value. This data persists between invocations, and is not removed until the checkpoint is restored.

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amaabca/aws-lex-conversation. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/amaabca/aws-lex-conversation/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `Aws::Lex::Conversation` project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/amaabca/aws-lex-conversation/blob/master/CODE_OF_CONDUCT.md).
