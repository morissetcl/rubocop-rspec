# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      module FactoryBot
        # Use implicit, explicit or inline definition in factory association rather than hard coding a strategy.
        #
        # @example
        #   # bad - only works for one strategy
        #   factory :foo do
        #     profile { create(:profile) }
        #   end
        #
        #   # good - implicit
        #   factory :foo do
        #     profile
        #   end
        #
        #   # good - explicit
        #   factory :foo do
        #     association :profile
        #   end
        #
        #   # good - inline
        #   factory :foo do
        #     profile { association :profile }
        #   end
        #
        class FactoryAssociationWithStrategy < Base
          FACTORY_CALLS = RuboCop::RSpec::FactoryBot::Language::METHODS

          MSG = 'Prefer implicit, explicit or inline definition rather than hard coding a strategy for setting association within factory.'

          def_node_matcher :factory_strategy_association, <<~PATTERN
            (block (send nil? :factory ...)
              ...
            )
          PATTERN

          def on_block(node)
            factory_strategy_association(node) do
              check_for_used_strategy(node)
            end
          end

          private

          def check_for_used_strategy(node)
            nodes_childs_blocks = node.each_node(:block).drop(1)
            nodes_childs_blocks.each do |block|
              attribute_block_node = block.child_nodes.last
              if using_strategy?(attribute_block_node)
                add_using_strategy_offense(attribute_block_node)
              end
            end
          end

          def add_using_strategy_offense(node)
            add_offense(
              node,
              message: MSG
            )
          end

          def using_strategy?(node)
            node.node_parts.find { |node_part| FACTORY_CALLS.include?(node_part) }
          end
        end
      end
    end
  end
end
