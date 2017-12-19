# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Admin
        # This class represents a draw for selecting proposals.
        class Draw
          attr_reader :sortition

          # Sugar syntax. Retrieves the list of selected proposals.
          def self.for(sortition)
            new(sortition).results
          end

          # Initializes the draw class. Receives a sortition.
          def initialize(sortition)
            @sortition = sortition
          end

          # Executes the draw and return the selected proposal ids.
          def results
            proposals = ParticipatorySpaceProposals.for(sortition).to_a
            proposals.sample(sortition.target_items, random: Random.new(sortition.seed)).pluck(:id)
          end
        end
      end
    end
  end
end
