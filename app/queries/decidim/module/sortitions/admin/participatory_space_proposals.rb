# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Admin
        class ParticipatorySpaceProposals < Rectify::Query
          # Sugar syntax. Retrieve all proposals for the given sortition.
          def self.for(sortition)
            new(sortition).query
          end

          # Initializes the class.
          #
          # sortition - a sortition to select proposals
          def initialize(sortition)
            @sortition = sortition
            @category = sortition.category
            @request_timestamp = sortition.request_timestamp
          end

          # Given a particpiatory process retrieves its proposals
          #
          # Returns an ActiveRecord::Relation.
          def query
            if category.nil?
              return Decidim::Proposals::Proposal
                     .where("created_at < ?", request_timestamp)
                     .where(feature: proposals_feature)
                     .order(id: :asc)
            end

            Decidim::Proposals::Proposal
              .where(feature: proposals_feature)
              .where("created_at < ?", request_timestamp)
              .where(category: category)
              .order(id: :asc)
          end

          private

          attr_reader :sortition, :category, :request_timestamp

          def proposals_feature
            Feature.find(sortition.decidim_proposals_feature_id)
          end
        end
      end
    end
  end
end
