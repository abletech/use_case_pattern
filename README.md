# UseCasePattern

[![Build Status](https://travis-ci.org/AbleTech/use_case_pattern.svg?branch=master)](https://travis-ci.org/AbleTech/use_case_pattern)

A module that helps you to implement the Use Case design pattern.

This pattern is widely used by the teams at Abletech. We were first introduced to this pattern by Shevaun Coker at RubyConf AU 2015 in Melbourne, Australia. You can read more about this pattern in her blog post A [Case for Use Cases](http://webuild.envato.com/blog/a-case-for-use-cases/), and also in the [video of the presentation](https://rubyconf.eventer.com/rubyconf-australia-2015-1223/a-case-for-use-cases-by-shevaun-coker-1734) that she gave. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'use_case_pattern'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install use_case_pattern

## Basic Usage

When you follow the use case design pattern, you normally define a class with a constructor, and a perform method. You should include the `UseCasePattern` module. Here is a simple example:

```ruby 
class NumberMultiplier
  include UseCasePattern

  attr_reader :product
  
  validates :number1, :number2, presence: true

  def initialize(number1, number2)
    @number1 = number1
    @number2 = number2
  end
  
  def perform
    if valid?
      @product = number1 * number2
    end
  end
  
  private
  
  attr_reader :number1, :number2
end
```

You could call this simple example from a Rails Controller, or anywhere else really. Here is an example:

```ruby
  def multiply
    multiplier = NumberMultiplier.perform(params[:number1], params[:number2])
    
    if multiplier.success?
      @result = multiplier.result
    else
      redirect_to :new, notice: multiplier.errors.full_messages
    end
  end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/abletech/use_case_pattern.
