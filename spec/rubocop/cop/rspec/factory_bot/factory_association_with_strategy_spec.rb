# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::FactoryBot::FactoryAssociationWithStrategy do
  context 'when passing a `create` stategy' do
    it 'flags the strategy' do
      expect_offense(<<~RUBY)
        factory :foo, class: 'FOOO' do
          profile { create(:profile) }
                    ^^^^^^^^^^^^^^^^ Prefer implicit, explicit or inline definition rather than hard coding a strategy for setting association within factory.
          profile { association :profile }
        end
      RUBY
    end
  end

  context 'when passing a `build` stategy' do
    it 'flags the strategy' do
      expect_offense(<<~RUBY)
        factory :profile do
          profile { build(:profile) }
                    ^^^^^^^^^^^^^^^ Prefer implicit, explicit or inline definition rather than hard coding a strategy for setting association within factory.
        end
      RUBY
    end
  end

  context 'when passing a `build_stubbed` stategy' do
    it 'flags the strategy' do
      expect_offense(<<~RUBY)
        factory :profile do
          profile { build_stubbed(:profile) }
                    ^^^^^^^^^^^^^^^^^^^^^^^ Prefer implicit, explicit or inline definition rather than hard coding a strategy for setting association within factory.
        end
      RUBY
    end
  end

  context 'when passing a block who does not use strategy' do
    context 'when passing an inline association' do
      it 'does not flag' do
        expect_no_offenses(<<~RUBY)
          factory :profile do
            profile { association :profile }
          end
        RUBY
      end
    end

    context 'when passing an implicit association' do
      it 'does not flag' do
        expect_no_offenses(<<~RUBY)
          factory :profile do
            profile
          end
        RUBY
      end
    end

    context 'when passing an explicit association' do
      it 'does not flag' do
        expect_no_offenses(<<~RUBY)
          factory :profile do
            association :profile
          end
        RUBY
      end
    end
  end
end
