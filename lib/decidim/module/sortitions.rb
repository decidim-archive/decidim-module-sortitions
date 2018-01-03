# frozen_string_literal: true

require "decidim/module/sortitions/admin"
require "decidim/module/sortitions/engine"
require "decidim/module/sortitions/admin_engine"
require "decidim/module/sortitions/feature"

module Decidim
  module Module
    # Base module for this engine.
    module Sortitions
      include ActiveSupport::Configurable

      # Public setting that defines how many elements will be shown
      # per page inside the administration view.
      config_accessor :items_per_page do
        15
      end
    end
  end
end
