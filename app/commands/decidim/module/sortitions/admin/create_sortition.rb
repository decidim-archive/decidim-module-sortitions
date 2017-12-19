# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Admin
        # Command that creates a sortition that selects proposals
        class CreateSortition < Rectify::Command
          # Public: Initializes the command.
          #
          # form - A form object with the params.
          def initialize(form)
            @form = form
          end

          # Executes the command. Broadcasts these events:
          #
          # - :ok when everything is valid.
          # - :invalid if the form wasn't valid and we couldn't proceed.
          #
          # Returns nothing.
          def call
            return broadcast(:invalid) if form.invalid?

            ActiveRecord::Base.transaction do
              sortition = create_sortition
              select_proposals_for(sortition)

              broadcast(:ok, sortition)
            end
          end

          private

          attr_reader :form

          def create_sortition
            Sortition.create!(
              feature: form.current_feature,
              decidim_proposals_feature_id: form.decidim_proposals_feature_id,
              request_timestamp: Time.now.utc,
              decidim_category_id: form.decidim_category_id,
              dice: form.dice,
              target_items: form.target_items,
              selected_proposals: []
            )
          end

          def select_proposals_for(sortition)
            proposals = Draw.for(sortition)
            sortition.update(selected_proposals: proposals) unless proposals.empty?
          end
        end
      end
    end
  end
end
