# Aws::Lex::Conversation

TODO - Write a description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws-lex-conversation'
```

And then execute:

```bash
bundle install
```

## Usage

At a high level, you must create a new instance of `Aws::Lex::Conversation`:

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amaabca/aws-lex-conversation. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/amaabca/aws-lex-conversation/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Aws::Lex::Conversation project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/amaabca/aws-lex-conversation/blob/master/CODE_OF_CONDUCT.md).
