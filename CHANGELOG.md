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
