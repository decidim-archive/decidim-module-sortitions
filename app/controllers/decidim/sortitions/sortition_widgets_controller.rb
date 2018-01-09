# frozen_string_literal: true

module Decidim
  module Sortitions
    class SortitionWidgetsController < Decidim::WidgetsController
      helper Decidim::SanitizeHelper
      helper Sortitions::SortitionsHelper

      private

      def model
        @model ||= Sortition.where(feature: params[:feature_id]).find(params[:sortition_id])
      end

      def iframe_url
        @iframe_url ||= sortition_sortition_widget_url(model)
      end
    end
  end
end
