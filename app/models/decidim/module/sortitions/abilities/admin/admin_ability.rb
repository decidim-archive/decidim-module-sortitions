# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module Abilities
        module Admin
          # Defines the abilities for a user in the admin section. Intended to be
          # used with `cancancan`.
          class AdminAbility < Decidim::Abilities::AdminAbility
            def define_abilities
              super

              can :manage, Sortition
            end
          end
        end
      end
    end
  end
end
