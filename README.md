# AutomateSoup

[![Build Status](https://travis-ci.org/skylerto/automate_soup.svg?branch=master)](https://travis-ci.org/skylerto/automate_soup)

Automate Soup is a Ruby API for interacting with the Soup that is Chef Automate.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'automate_soup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install automate_soup

## Usage

### Setting up the Client

You can setup the client in a generic way via:

``` ruby
soup = AutomateSoup.setup(
  url: ENV['AUTOMATE_URL'],
  username: ENV['AUTOMATE_USERNAME'],
  token: ENV['AUTOMATE_TOKEN']
)
```

You can also setup the client with an enterprise, organization, project, and
pipeline via:

``` ruby
soup = AutomateSoup.setup(
  url: ENV['AUTOMATE_URL'],
  username: ENV['AUTOMATE_USERNAME'],
  token: ENV['AUTOMATE_TOKEN'],
  organization: organization,
  project: project,
  pipeline: pipeline
)
```

### Fetching Changes

``` ruby
# To fetch an array of pipeline change topic names
changes = soup.pipeline_topics(
  organization: organization,
  project: project,
  pipeline: pipeline
)

# To fetch a specific change via a topic
change = soup.change_by_topic(
  organization: organization,
  project: project,
  pipeline: pipeline,
  topic: 'blahblahblah'
)

change = soup.change_by_topic(
  topic: 'blahblahblah'
)
```

### Approving Changes

``` ruby
# If you used the first way to setup the client
soup.approve_change(
  organization: organization,
  project: project,
  pipeline: pipeline,
  topic: 'blahblahblah',
  wait: true
)

# If you used the second
soup.approve_change(
  topic: 'blahblahblah',
  wait: true
)
```

### Delivering Changes

``` ruby
# If you used the first way to setup the client
soup.deliver_change(
  organization: organization,
  project: project,
  pipeline: pipeline,
  topic: 'blahblahblah',
  wait: true
)

# If you used the second
soup.deliver_change(
  topic: 'blahblahblah',
  wait: true
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/automate_soup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AutomateSoup project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/automate_soup/blob/master/CODE_OF_CONDUCT.md).
