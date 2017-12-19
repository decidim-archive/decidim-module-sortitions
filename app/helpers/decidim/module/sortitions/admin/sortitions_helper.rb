# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Admin
        module SortitionsHelper
          include Decidim::TranslationsHelper

          # Converst a list of features into a list of selectable options
          def features_options(features)
            features.map do |f|
              [translated_attribute(f.name), f.id]
            end
          end

          def sortition_category(sortition)
            return translated_attribute sortition.category&.name if sortition.category

            I18n.t("sortition.form.all_categories", scope: "decidim.admin")
          end
        end
      end
    end
  end
end
