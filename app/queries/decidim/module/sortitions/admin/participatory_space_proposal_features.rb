# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Admin
        # Query that retrieves a list of proposal features
        class ParticipatorySpaceProposalFeatures < Rectify::Query
          attr_reader :participatory_space

          # Sugar syntax. Allow retrieving all proposal features for the
          # given participatory space.
          def self.for(participatory_space)
            new(participatory_space).query
          end

          # Initializes the query
          def initialize(participatory_space)
            @participatory_space = participatory_space
          end

          def query
            Feature
              .where(participatory_space: participatory_space, manifest_name: "proposals")
              .published
          end
        end
      end
    end
  end
end
