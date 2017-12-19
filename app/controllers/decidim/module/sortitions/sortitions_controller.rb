# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      # Exposes the sortition resource so users can view them
      class SortitionsController < Decidim::Module::Sortitions::ApplicationController
        helper_method :sortition

        helper Decidim::Proposals::ApplicationHelper

        def index; end

        private

        def sortition
          Sortition.where(feature: current_feature).order(created_at: :desc).first
        end
      end
    end
  end
end
