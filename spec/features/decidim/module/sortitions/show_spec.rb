# frozen_string_literal: true

require "spec_helper"

describe "show", type: :feature do
  include_context "with a feature"
  let(:manifest_name) { "sortitions" }

  context "when shows the sortition feature" do
    let!(:sortition) { create(:sortition, feature: feature) }

    before do
      visit_feature
      click_link "View sortition"
    end

    it "shows the sortition additional info" do
      expect(page).to have_content(sortition.additional_info[:en])
    end

    it "shows the sortition witnesses" do
      expect(page).to have_content(sortition.witnesses[:en])
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
      click_link "View sortition"
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

  context "when cancelled sortition" do
    let!(:sortition) { create(:sortition, :cancelled, feature: feature) }

    before do
      page.visit "#{main_feature_path(feature)}?filter[state]=cancelled"
      click_link "View sortition"
    end

    it "shows the cancel reasons" do
      expect(page).to have_content(sortition.cancel_reason[:en])
    end
  end
end
