# frozen_string_literal: true

require "decidim/faker/localized"
require "decidim/core/test/factories"
require "decidim/participatory_processes/test/factories"

FactoryBot.define do
  factory :sortition_feature, parent: :feature do
    name { Decidim::Features::Namer.new(participatory_space.organization.available_locales, :sortitions).i18n_name }
    manifest_name :sortitions
    participatory_space { create(:participatory_process, :with_steps, organization: organization) }
  end

  factory :sortition, class: "Decidim::Module::Sortitions::Sortition" do
    feature { create(:sortition_feature) }
    decidim_proposals_feature { create(:proposal_feature, organization: feature.organization) }

    title { Decidim::Faker::Localized.sentence(3) }
    author do
      create(:user, :admin, organization: feature.organization) if feature
    end

    dice { Faker::Number.between(1, 6).to_i }
    target_items { Faker::Number.between(1, 5).to_i }
    request_timestamp { Time.now.utc }
    witnesses { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
    additional_info { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
    selected_proposals { create_list(:proposal, target_items, feature: decidim_proposals_feature).pluck(:id) }

    trait :cancelled do
      cancelled_on { Time.now.utc }
      cancel_reason { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
      cancelled_by_user { create(:user, :admin, organization: feature.organization) if feature }
    end
  end
end
