require 'spec_helper'

RSpec.describe 'be_invalid_on matcher' do
  let(:matchers) { MatchersMock.new }
  before { ValidationExamplesMatcher.register(matchers) }
  let(:model) { TestModel.new }

  let(:match_block) { matchers.match_blocks[:be_invalid_on] }
  let(:chain_blocks) { matchers.chain_blocks[:be_invalid_on] }
  let(:with_chain_block) { chain_blocks&.[](:with) }
  let(:on_context_chain_block) { chain_blocks&.[](:on_context) }
  let(:failure_message_block) { matchers.failure_message_blocks[:be_invalid_on] }

  it 'is registered with match block' do
    expect(match_block).to be_kind_of(Proc)
  end

  describe 'match block' do
    let(:model) { double('model') }
    before { matchers.instance_exec(:a_value, &with_chain_block) }

    context 'without on_context chain' do
      it "calls model's setter and valid?" do
        expect(model).to receive(:attr=).with(:a_value)
        expect(model).to receive(:invalid?).with(nil)
        matchers.instance_exec(model, &match_block)
      end
    end

    context 'with on_context chain' do
      before { matchers.instance_exec(:a_context, &on_context_chain_block) }
      it "calls model's setter and valid?" do
        expect(model).to receive(:attr=).with(:a_value)
        expect(model).to receive(:invalid?).with(:a_context)
        matchers.instance_exec(model, &match_block)
      end
    end
  end

  it 'is registered with :with chain block' do
    expect(with_chain_block).to be_kind_of(Proc)
  end

  describe 'with chain block' do
    it 'sets @value' do
      matchers.instance_exec(:a_value, &with_chain_block)
      expect(matchers.value).to eq :a_value
    end
  end

  it 'is registered with :on_context chain block' do
    expect(on_context_chain_block).to be_kind_of(Proc)
  end

  describe 'with on_context block' do
    it 'sets @context' do
      matchers.instance_exec(:a_context, &on_context_chain_block)
      expect(matchers.context).to eq :a_context
    end
  end


  it 'is registered with failure_message block' do
    expect(failure_message_block).to be_kind_of(Proc)
  end

  describe 'failure_message block' do
    context 'the model is valid' do
      before { model.attr = 'ok' }
      it 'returns message saying "it should be invalid"' do
        expect(matchers.instance_exec(model, &failure_message_block))
          .to eq 'expect TestModel to be invalid, but it is VALID.'
      end
    end

    context 'the model is invalid but it has no errors' do
      let(:model) { double('model') }
      it 'returns message saying "it should have errors"' do
        expect(model).to receive(:valid?) { false }
        expect(matchers.instance_exec(model, &failure_message_block))
          .to eq 'expect RSpec::Mocks::Double to have errors on attr, but EMPTY.'
      end
    end
  end
end
