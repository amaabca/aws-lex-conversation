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
