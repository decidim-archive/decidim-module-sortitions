# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Module
    module Sortitions
      module Abilities
        module Admin
          describe AdminAbility do
            subject { described_class.new(user, {}) }

            let(:user) { build(:user, :admin) }

            it { is_expected.to be_able_to(:manage, Decidim::Module::Sortitions::Sortition) }
          end
        end
      end
    end
  end
end
