# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Admin
        # Controller responsible of the sortition that selects proposals from
        # a participatory space.
        class SortitionsController < Admin::ApplicationController
          helper_method :proposal_features

          def show
            authorize! :show, Sortition
          end

          def new
            authorize! :create, Sortition
            @form = sortition_form.instance(current_participatory_space: current_participatory_space)
          end

          def create
            authorize! :create, Sortition
            @form = sortition_form.from_params(params, current_participatory_space: current_participatory_space)
            CreateSortition.call(@form) do
              on(:ok) do |sortition|
                flash[:notice] = I18n.t("sortition.create.success", scope: "decidim.admin")
                redirect_to sortition_path(feature_id: sortition.feature.id, participatory_process_slug: sortition.feature.participatory_space.slug, id: sortition.id)
              end

              on(:invalid) do
                flash.now[:alert] = I18n.t("sortition.create.error", scope: "decidim.admin")
                render :new
              end
            end
          end

          private

          def sortition_form
            form(SortitionForm)
          end

          def proposal_features
            ParticipatorySpaceProposalFeatures.for(current_participatory_space)
          end
        end
      end
    end
  end
end
