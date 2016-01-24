require 'spec_helper'

describe ValidationExamplesMatcher do
  it 'has a version number' do
    expect(ValidationExamplesMatcher::VERSION).not_to be nil
  end

  let(:matchers) { MatchersMock.new }
  before { ValidationExamplesMatcher.register(matchers) }

  it 'registers :be_valid_on matcher' do
    expect(matchers.defined_matchers).to include(:be_valid_on)
  end

  it 'registers :be_invalid_on matcher' do
    expect(matchers.defined_matchers).to include(:be_invalid_on)
  end
end
