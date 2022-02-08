# 6.4.0 - Feb 9, 2022

* Add support for the new protocol properties of `proposedNextState` and `transcriptions`. This enables support for [transcription confidence scores](https://docs.aws.amazon.com/lexv2/latest/dg/using-transcript-confidence-scores.html).
* Expose the following methods on `Aws::Lex::Conversation` instances:
  - `proposed_next_state?`: Returns `true` if a `proposedNextState` value is present or `false` otherwise.
  - `proposed_next_state`: Returns an `Aws::Lex::Conversation::Type::ProposedNextState` instance. May return `nil`.
  - `transcriptions`: Returns an array of `Aws::Lex::Conversation::Type::Transcription` instances. Defaults to a empty array if the `transcriptions` property is not present.

# 6.3.0 - Nov 22, 2021

* Add support for the recently added `slotElicitationStyle` property when generating an `ElicitSlot` repsonse ([documentation](https://docs.aws.amazon.com/lexv2/latest/dg/using-spelling.html)).

You can generate an `ElicitSlot` response now with an optional `slot_elicitation_style` property to allow for spelling support:

```ruby
conversation.elicit_slot(
  slot_to_elicit: 'LastName',
  slot_elicitation_style: 'SpellByWord' # one of Default, SpellByLetter, or SpellByWord
)
```

# 6.2.0 - Sept 28, 2021

* Add a `Aws::Lex::Conversation#restore_from!` method that accepts a checkpoint parameter. This method modifies the underlying conversation state to match the data from the saved checkpoint.
* Make the `dialog_action_type` parameter on `Aws::Lex::Conversation#checkpoint!` default to `Delegate` if not specified as a developer convenience.
* Allow developers to pass an optional `intent` override parameter on `Aws::Lex::Conversation#checkpoint!` for convenience.
* Update the README with advanced examples for the conversation stash and checkpoints.

# 6.1.1 - Sept 22, 2021

* renamed `maximum_elicitations` to `max_retries` and made it backwards compatible to make the param name clear, by default this value is zero, allowing each slot to elicit only once

# 6.1.0 - Sept 7, 2021

Added helper methods for clearing active contexts

```ruby
conversation.clear_context!(name: 'test') # clears this specific active context
conversation.clear_all_contexts! # clears all current active contexts
```

# 6.0.0 - Sept 7, 2021

* **breaking change** - Modify `Aws::Lex::Conversation::Type::Base#computed_property` to accept a block instead of a callable argument. This is an internal class and should not require any application-level changes.
* **breaking change** - Add a required `alias_name` attribute on `Aws::Lex::Conversation::Type::Bot` instances. Please note that the Version 2 of AWS Lex correctly returns this value as input to lambda functions. Therefore no application-level changes are necessary.
* Implement a new set of test helpers to make it easier to modify state and match test expectations. You can use the test helpers as follows:

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

* Add a few convenience methods to `Aws::Lex::Conversation` instances for dealing with active contexts:
  - `#active_context(name:)`:

     Returns the active context instance that matches the name parameter.

  - `#active_context?(name:)`:

     Returns true/false depending on if an active context matching
     the name parameter is found.

  - `#active_context!(name:, turns:, seconds:, attributes:)`:

     Creates or updates an existing active context instance for
     the conversation.

# 5.1.0 - Sept 2, 2021

* Allow the intent to be specified when returning a response such as `elicit_slot`.

# 5.0.0 - August 30, 2021

* **breaking change** - `Aws::Lex::Conversation::Support::Mixins::SlotElicitation`
  - Rename the `message` attribute to `messages`. This attribute must be a callable that returns and array of `Aws::Lex::Conversation::Type::Message` instances.
  - rename the `follow_up_message` attribute to `follow_up_messages`. This must also be a callable that returns an array of message instances.
* Allow the `fallback` callable in `SlotElicitation` to be nilable. The slot value will not be elicited if the value is nil and maximum attempts have been exceeded.

# 4.3.0 - August 25, 2021

* Slot elicitor can now be passed an Aws::Lex::Conversation::Type::Message as part of the DSL/callback and properly formats the response as such

# 4.1.0 - July 21, 2021

* Don't set the `intent` property in the response for `ElicitIntent`
  actions as the field is optional as per [AWS documentation](https://docs.aws.amazon.com/lexv2/latest/dg/lambda.html#lambda-response-format).
* Add `InProgress` and `ReadyForFulfillment` enumerations to `FulfillmentState`.

# 4.0.1 - July 16, 2021

* Fix a bug with the `Aws::Lex::Conversation::Handler::Echo` class because it
  didn't correctly return an array of messages required for Lex V2.
* Drop a call to `Hash#deep_symbolize_keys` so we don't implicitly rely on
  ActiveSupport.
* Call `Hash#compact` when transforming a Lex response so we don't include any
  `nil` values in the response.

# 4.0.0 - July 14, 2021

**breaking change** - Drop support for the Lex runtime version 1. If you are using Lex Version 1, please lock this gem to `~> 3.0.0`.
**breaking change** - Implement support and types for [Lex Version 2](https://docs.aws.amazon.com/lexv2/latest/dg/what-is.html), which implements a new Lambda [input/output event format](https://docs.aws.amazon.com/lexv2/latest/dg/lambda.html#lambda-input-format).

# 3.1.0 - June 1, 2021

* Default both `request_attributes` and `session_attributes`
  to an empty Hash when the values from the event are `null`.
  It is much easier to reason and write logic when you can
  assume that these values are always at least a hash.

# 3.0.0 - May 20, 2021

* **breaking change** - Don't pass the `recentIntentSummaryView` back
  in the Lex response unless we have modified or added an existing
  checkpoint. Lex will persist the previous intent summary/history
  if we do not send a `recentIntentSummaryView` value back in the
  response (see [1]).
* Add a few helper methods to the `Aws::Lex::Conversation::Type::Slot`
  instances:

  - `active?`: returns true if the slot is defined (either optional or
             required) for the current intent.
  - `requestable?`: returns true if the slot is active for the current
                  intent and it is not filled.

[1]: https://docs.aws.amazon.com/lex/latest/dg/lambda-input-response-format.html#lambda-response-recentIntentSummaryView

# 2.0.0 - August 19, 2020

* **breaking change:** Rename `Aws::Lex::Conversation::Type::CurrentIntent` to `Aws::Lex::Conversation::Type::Intent`.
* **breaking change:** Built-in handlers now default the `options` attribute to an empty hash.
* Add Lex NLU model improvement functionality (see: https://aws.amazon.com/about-aws/whats-new/2020/08/amazon-lex-launches-accuracy-improvements-and-confidence-scores/).
* Add the `intent_confidence` method to the conversation class that may be used as follows:

```ruby
# NOTE: Lex model improvements must be enabled on the bot to get confidence data.
# SEE: https://aws.amazon.com/about-aws/whats-new/2020/08/amazon-lex-launches-accuracy-improvements-and-confidence-scores/
conversation.intent_confidence.ambiguous?         # true/false
conversation.intent_confidence.unambiguous?       # true/false
conversation.intent_confidence.candidates         # [...] the array contains the current_intent and all similar intents
conversation.intent_confidence.similar_alternates # [...] the array doesn't contain the current_intent
```

* The calculation used to determine intent ambiguity by default looks for confidence scores that are within a standard deviation of the current intent's confidence score.
* You can pass your own static `threshold` parameter if you wish to change this behaviour:

```ruby
conversation.intent_confidence.ambiguous?(threshold: 0.4) # true/false
```

* Implement a built-in `SlotResolution` handler that is intended to act as the initial handler in the chain. This handler will resolve all slot values to their top resolution, then call the successor handler.
