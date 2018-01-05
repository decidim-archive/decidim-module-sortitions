# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      # This is the engine that runs on the administration interface of `decidim_module_sorititions`.
      # It mostly handles rendering the created projects associated to a participatory
      # process.
      class AdminEngine < ::Rails::Engine
        isolate_namespace Decidim::Module::Sortitions::Admin

        paths["db/migrate"] = nil

        routes do
          resources :sortitions do
            get "confirm_destroy", on: :member
          end

          root to: "sortitions#index"
        end

        initializer "decidim_module_sortitions_admin.inject_abilities_to_user" do |_app|
          Decidim.configure do |config|
            config.admin_abilities += [
              "Decidim::Module::Sortitions::Abilities::Admin::AdminAbility"
            ]
          end
        end

        def load_seed
          nil
        end
      end
    end
  end
end
