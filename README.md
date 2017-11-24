# Emailable

A simple class to test the validity of an email address against the smtp server supposed to handle its intended messages.

It resolves the smtp server using `Resolv::DNS` then contacts it to check its reaction when trying to send an email. No actual email is sent. The smtp session is closed after each check.

Since this is not a spammer helper tool, you need to provide a sender address that will be used during the check. The domain name will be submitted in the HELO command and the full address will be submitted in the RCPT TO command.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'emailable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install emailable

## Usage

### Immediate mode

(replace sender address with yours or it will fail)

```ruby
Emailable.true?('destination@example.com', 'sender@yourname.xyz')
```

or (pedantic mode that raises an exception)

```ruby
begin
  Emailable.true!('destination@example.com', 'sender@yourname.xyz')
rescue Emailable::Refused
end
```

### Instanciated mode

```ruby
checker = Emailable::Checker.new('sender@yourname.xyz')
checker.emailable?('destination@example.com')
```

or

```ruby
checker = Emailable::Checker.new
checker.sender = 'sender@yourname.xyz'
checker.emailable?('destination@example.com')
checker.true!('destination@example.com')
```

## Caveat Emptor

Most smtp servers will have quotas in place. This class does not try to limit the request rate so you should do it yourself lest you will be throttled or blacklisted by the server.

## TODO

 * Optimize response parsing to get rid of safety delays
 * Offer bulk check mode to verify multiple addresses in one call
 * Support SSL and TLS
 * Specify server port (currently uses 25)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ameuret/emailable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Emailable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ameuret/emailable/blob/master/CODE_OF_CONDUCT.md).
