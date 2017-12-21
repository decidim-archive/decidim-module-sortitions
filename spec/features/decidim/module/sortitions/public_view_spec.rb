# frozen_string_literal: true

require "spec_helper"

describe "public view", type: :feature do
  include_context "with a feature"
  let(:manifest_name) { "sortitions" }

  context "when shows the sortition feature" do
    before do
      visit_feature
    end

    it "shows the sortition feature description" do
      expect(page).to have_content(feature.settings.description[:en])
    end
  end

  context "when sortition result" do
    let(:sortition) { create(:sortition, feature: feature) }
    let!(:proposals) do
      create_list(:proposal, 10,
                  feature: sortition.decidim_proposals_feature,
                  created_at: sortition.request_timestamp - 1.day)
    end

    before do
      sortition.update(selected_proposals: Decidim::Module::Sortitions::Admin::Draw.for(sortition))
      visit_feature
    end

    it "There are selected proposals" do
      expect(sortition.selected_proposals).not_to be_empty
    end

    it "Shows all selected proposals" do
      sortition.proposals.each do |p|
        expect(page).to have_content(translated(p.title))
      end
    end
  end
end
