# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      # Exposes the sortition resource so users can view them
      class SortitionsController < Decidim::Module::Sortitions::ApplicationController
        include FilterResource
        include Orderable
        include Paginable

        helper_method :sortition

        helper Decidim::Proposals::ApplicationHelper

        def index
          @sortitions = search
                        .results
                        .includes(:author)
                        .includes(:category)

          @sortitions = paginate(@sortitions)
          @sortitions = reorder(@sortitions)
        end

        private

        def sortition
          Sortition.find(params[:id])
        end

        def search_klass
          SortitionSearch
        end

        def default_filter_params
          {
            search_text: "",
            category_id: ""
          }
        end
      end
    end
  end
end
