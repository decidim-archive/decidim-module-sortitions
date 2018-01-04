# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Admin
        # Controller responsible of the sortition that selects proposals from
        # a participatory space.
        class SortitionsController < Admin::ApplicationController
          helper_method :proposal_features

          def index; end

          def show
            authorize! :show, sortition
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
                flash[:notice] = I18n.t("sortitions.create.success", scope: "decidim.module.sortitions.admin")
                redirect_to sortition_path(feature_id: sortition.feature.id, participatory_process_slug: sortition.feature.participatory_space.slug, id: sortition.id)
              end

              on(:invalid) do
                flash.now[:alert] = I18n.t("sortitions.create.error", scope: "decidim.module.sortitions.admin")
                render :new
              end
            end
          end

          def confirm_destroy
            authorize! :destroy, sortition
            @form = destroy_sortition_form.from_model(sortition, current_participatory_space: current_participatory_space)
          end

          def destroy
            authorize! :destroy, sortition
            @form = destroy_sortition_form.from_params(params, current_participatory_space: current_participatory_space)
            DestroySortition.call(@form) do
              on(:ok) do |sortition|
                flash[:notice] = I18n.t("sortitions.destroy.success", scope: "decidim.module.sortitions.admin")
                redirect_to sortitions_path(feature_id: sortition.feature.id, participatory_process_slug: sortition.feature.participatory_space.slug)
              end

              on(:invalid) do
                flash.now[:alert] = I18n.t("sortitions.destroy.error", scope: "decidim.module.sortitions.admin")
                render :confirm_destroy
              end
            end
          end

          private

          def sortition_form
            form(SortitionForm)
          end

          def destroy_sortition_form
            form(DestroySortitionForm)
          end

          def proposal_features
            ParticipatorySpaceProposalFeatures.for(current_participatory_space)
          end
        end
      end
    end
  end
end
