# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Admin
        # This controller is the abstract class from which all other controllers of
        # this engine inherit.
        #
        # Note that it inherits from `Decidim::Features::BaseController`, which
        # override its layout and provide all kinds of useful methods.
        class ApplicationController < Decidim::Admin::Features::BaseController
          helper_method :sortitions, :sortition

          def sortitions
            @sortitions ||= Sortition.where(feature: current_feature)
          end

          def sortition
            @sortition ||= sortitions.find(params[:id])
          end
        end
      end
    end
  end
end
