require 'spec_helper'

describe ActiveModel::Serializer::CanCan::Abilities do
  let(:user) { User.first }
  let(:category) { Category.first }

  describe 'sane' do
    it do
      expect(user).to_not be_nil
      expect(category).to_not be_nil
    end
  end

  class MockAbility
    include CanCan::Ability
    def initialize(user)
      can :manage, Category
      cannot :read, Category
    end
  end

  describe '.abilities' do
    let(:serializer) do
      Class.new(ActiveModel::Serializer) do
        attribute :id
        abilities :restful, :foo, :bar
        def current_ability
          MockAbility.new(nil)
        end

        def can_foo?
          true
        end

        def can_bar?
          cannot? :read, Category
        end
      end
    end

    let(:category_serializer) { serializer.new(category, scope: user) }

    context 'serializable_hash' do
      subject { category_serializer.serializable_hash }
      its(:keys) { should eq [:id, :can] }
    end

    context 'abilities key' do
      subject { category_serializer.serializable_hash[:can] }
      its([:restful]) { should be_nil }
      its([:update]) { should be true }
      its([:show]) { should be false }
      its([:foo]) { should be true }
      its([:bar]) { should be true }
    end
  end
end
