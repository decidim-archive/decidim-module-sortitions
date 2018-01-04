# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      # Model that encapsulates the parameters of a sortion
      class Sortition < ApplicationRecord
        include Decidim::HasCategory
        include Decidim::Authorable
        include Decidim::HasFeature
        include Decidim::HasReference

        feature_manifest_name "sortitions"

        belongs_to :decidim_proposals_feature,
                   foreign_key: "decidim_proposals_feature_id",
                   class_name: "Decidim::Feature"

        belongs_to :cancelled_by_user,
                   foreign_key: "cancelled_by_user_id",
                   class_name: "Decidim::User",
                   optional: true

        before_validation :initialize_reference

        scope :categorized_as, lambda { |category_id|
          includes(:categorization)
            .where("decidim_categorizations.decidim_category_id" => category_id)
        }

        scope :active, -> { where(cancelled_on: nil) }
        scope :cancelled, -> { where.not(cancelled_on: nil) }

        def proposals
          Decidim::Proposals::Proposal.where(id: selected_proposals)
        end

        def similar_count
          Sortition.where(feature: feature)
                   .where(decidim_proposals_feature: decidim_proposals_feature)
                   .categorized_as(category&.id)
                   .where(target_items: target_items)
                   .count
        end

        def seed
          request_timestamp.to_i * dice
        end

        def author_name
          author&.name
        end

        def author_avatar_url
          author&.avatar&.url || ActionController::Base.helpers.asset_path("decidim/default-avatar.svg")
        end

        def cancelled_by_user_avatar_url
          cancelled_by_user&.avatar&.url || ActionController::Base.helpers.asset_path("decidim/default-avatar.svg")
        end

        def cancelled?
          cancelled_on.present?
        end

        def self.order_randomly(seed)
          transaction do
            connection.execute("SELECT setseed(#{connection.quote(seed)})")
            order("RANDOM()").load
          end
        end

        private

        def initialize_reference
          self[:reference] ||= calculate_reference
        end
      end
    end
  end
end
