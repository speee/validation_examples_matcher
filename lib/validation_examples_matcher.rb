require "validation_examples_matcher/version"
require 'rspec/expectations'

module ValidationExamplesMatcher
  def self.register(matchers = RSpec::Matchers)
    matchers.define :be_valid_on do |attr_name|
      match do |model|
        model.send("#{attr_name}=", @value)
        model.valid?(@context)
      end

      chain :with do |value|
        @value = value
      end

      chain :on_context do |context|
        @context = context
      end

      failure_message do |model|
        "expect #{model.class} to be valid, but it is INVALID."
      end
    end

    matchers.define :be_invalid_on do |attr_name|
      match do |model|
        model.send("#{attr_name}=", @value)
        model.invalid?(@context) && model.errors[attr_name].size >= 1
      end

      chain :with do |value|
        @value = value
      end

      chain :on_context do |context|
        @context = context
      end

      failure_message do |model|
        if model.valid?(@context)
          "expect #{model.class} to be invalid, but it is VALID."
        else
          "expect #{model.class} to have errors on #{attr_name}, but EMPTY."
        end
      end
    end
  end

  register
end
