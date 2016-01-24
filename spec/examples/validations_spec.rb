require 'spec_helper'

RSpec.describe TestModel do
  subject { TestModel.new }

  context 'when target attribute has valid value' do
    it { is_expected.to be_valid_on(:attr).with('valid value') }
    it { is_expected.not_to be_invalid_on(:attr).with('valid value') }
  end

  context 'when target attribute has INVALID value' do
    it { is_expected.to be_invalid_on(:attr).with(nil) }
    it { is_expected.not_to be_valid_on(:attr).with(nil) }
  end

  context 'when target attribute is validated on a certain context' do
    context 'when target attribute has valid value' do
      it { is_expected.to be_valid_on(:attr).with('1234').on_context(:a_context) }
      it { is_expected.not_to be_invalid_on(:attr).with('1234').on_context(:a_context) }
    end

    context 'when target attribute has INVALID value' do
      it { is_expected.to be_invalid_on(:attr).with('12345').on_context(:a_context) }
      it { is_expected.not_to be_valid_on(:attr).with('12345').on_context(:a_context) }
    end
  end
end
