# ValidationExamplesMatcher

[![Build Status](https://travis-ci.org/nisshiee/validation_examples_matcher.svg?branch=master)](https://travis-ci.org/nisshiee/validation_examples_matcher)

ValidationExamplesMatcher supports writing rails model's validation specs.

e.g.

```ruby
RSpec.describe MyModel do
  ...

  it { is_expected.to be_invalid_on(:name).with(nil) }
  it { is_expected.to be_invalid_on(:name).with('') }
  it { is_expected.to be_valid_on(:name).with('my name') }
end
```

ValidationExamplesMatcher sets a particular value ― nil, empty string and 'my name' ― actually.
Then the matcher calls `valid?` or `invalid?` method and checks results of validation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'validation_examples_matcher'
```

And then execute:

    $ bundle

## Usage

Let me show how to use ValidationExamplesMatcher in case of following model.

```ruby
class MyModel < ActiveRecord::Base
  validates :name, presence: true
  validates :name, length: { maxmum: 4 }, on: :create
end
```

First, you have to define `subject` as target model object.
It's good to define it as *valid* object.
Creating object with [factory_girl](https://github.com/thoughtbot/factory_girl) is very nice.

```ruby
RSpec.define MyModel do
  subject { FactoryGirl.build(:my_model) }
  # subject { MyModel.new } => also ok but not recommended
end
```

Second, write *invalid case examples* and *valid case examples* using ValidationExamplesMatcher.
In case of `MyModel`, `:name` attribute is invalid when its' value is nil or empty string.
`'my name'` is typical valid example.

```ruby
RSpec.define MyModel do
  subject { FactoryGirl.build(:my_model) }

  it { is_expected.to be_invalid_on(:name).with(nil) }
  it { is_expected.to be_invalid_on(:name).with('') }
  it { is_expected.to be_valid_on(:name).with('my name') }
end
```

Arguments of `be_invalid_on` or `be_valid_on` indicate attribute name.
And arguments of `with` chain is a value which will be set to the attribute.

`ActiveModel::Validations` can define validations on specific contexts.
`MyModel` has `length` validation only on `:create` context.
You can also define validation spec for such case using `on_context` chain.

```ruby
RSpec.define MyModel do
  subject { FactoryGirl.build(:my_model) }

  it { is_expected.to be_invalid_on(:name).with(nil) }
  it { is_expected.to be_invalid_on(:name).with('') }
  it { is_expected.to be_valid_on(:name).with('my name') }

  it { is_expected.to be_valid_on(:name).with('4cha').on_context(:create) }
  it { is_expected.to be_invalid_on(:name).with('5char').on_context(:create) }
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nisshiee/validation_examples_matcher.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
