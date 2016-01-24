$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'validation_examples_matcher'
require 'active_model'
require 'pry'

class TestModel
  include ActiveModel::Model

  attr_accessor :attr
  validates :attr, presence: true
  validates :attr, length: { maximum: 4 }, on: :a_context
end

class MatchersMock < BasicObject
  attr_reader :defined_matchers, :match_blocks, :chain_blocks, :failure_message_blocks
  attr_reader :value, :context

  def define(name, &block)
    @defined_matchers ||= []
    @defined_matchers << name
    @current = name
    instance_exec(:attr, &block)
  end

  def match(&block)
    @match_blocks ||= {}
    @match_blocks[@current] = block
  end

  def chain(name, &block)
    @chain_blocks ||= {}
    @chain_blocks[@current] ||= {}
    @chain_blocks[@current][name] = block
  end

  def failure_message(&block)
    @failure_message_blocks ||= {}
    @failure_message_blocks[@current] = block
  end
end
