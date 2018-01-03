# frozen_string_literal: true

require "rails"
require "active_support/all"

require "decidim/core"

module Decidim
  module Module
    module Sortitions
      # Decidim's Sortitions Rails Engine.
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Module::Sortitions

        routes do
          resources :sortitions, only: [:index, :show]
          root to: "sortitions#index"
        end

        initializer "decidim_module_sorititions.assets" do |app|
          app.config.assets.precompile += %w(decidim_module_sortitions_manifest.js)
        end
      end
    end
  end
end
