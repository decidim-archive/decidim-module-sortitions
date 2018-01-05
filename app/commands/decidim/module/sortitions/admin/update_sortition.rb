# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Admin
        # Command that creates a sortition that selects proposals
        class UpdateSortition < Rectify::Command
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

            update_sortition
            broadcast(:ok, sortition)
          end

          private

          attr_reader :form

          def update_sortition
            sortition.update(
              title: form.title,
              additional_info: form.additional_info
            )
          end

          def sortition
            @sortition ||= Sortition.find(form.id)
          end
        end
      end
    end
  end
end
