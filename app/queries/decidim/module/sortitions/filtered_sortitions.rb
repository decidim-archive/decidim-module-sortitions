# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      # A class used to find sortitions filtered by features and a date range
      class FilteredSortitions < Rectify::Query
        # Syntactic sugar to initialize the class and return the queried objects.
        #
        # features - An array of Decidim::Feature
        # start_at - A date to filter resources created after it
        # end_at - A date to filter resources created before it.
        def self.for(features, start_at = nil, end_at = nil)
          new(features, start_at, end_at).query
        end

        # Initializes the class.
        #
        # features - An array of Decidim::Feature
        # start_at - A date to filter resources created after it
        # end_at - A date to filter resources created before it.
        def initialize(features, start_at = nil, end_at = nil)
          @features = features
          @start_at = start_at
          @end_at = end_at
        end

        # Finds the Proposals scoped to an array of features and filtered
        # by a range of dates.
        def query
          sortitions = Decidim::Module::Sortitions::Sortition.where(feature: @features)
          sortitions = sortitions.where("created_at >= ?", @start_at) if @start_at.present?
          sortitions = sortitions.where("created_at <= ?", @end_at) if @end_at.present?
          sortitions
        end
      end
    end
  end
end
