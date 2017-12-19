# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Admin
        class SortitionForm < Form
          mimic :sortition

          attribute :decidim_proposals_feature_id, Integer
          attribute :decidim_category_id, Integer
          attribute :dice, Integer
          attribute :target_items, Integer

          validates :decidim_proposals_feature_id, presence: true
          validates :dice,
                    presence: true,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 1,
                      less_than_or_equal_to: 6
                    }

          validates :target_items,
                    presence: true,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 1
                    }

          delegate :categories, to: :current_participatory_space

          def current_participatory_space
            context.try(:current_participatory_space)
          end

          def current_feature
            context.try(:current_feature)
          end
        end
      end
    end
  end
end
