# frozen_string_literal: true

require "spec_helper"

describe "sortitions", type: :system do
  include_context "with a feature"

  let(:manifest_name) { "sortitions" }
  let!(:user) { create :user, :confirmed, organization: participatory_process.organization }

  context "when listing sortitions in a participatory process" do
    it "lists all the sortitions" do
      create_list(:sortition, 3, feature: feature)
      visit_feature
      expect(page).to have_css(".card--sortition", count: 3)
    end

    context "when order by 'random'" do
      let!(:lucky_sortition) { create(:sortition, feature: feature) }
      let!(:unlucky_sortition) { create(:sortition, feature: feature) }

      it "lists the sortitions ordered randomly" do
        page.visit "#{main_feature_path(feature)}?order=random"

        expect(page).to have_selector(".card--sortition", count: 2)
        expect(page).to have_selector(".card--sortition", text: lucky_sortition.title[:en])
        expect(page).to have_selector(".card--sortition", text: unlucky_sortition.title[:en])
      end
    end

    context "when ordering by 'recent'" do
      it "lists the sortitions ordered by created at" do
        older = create(:sortition, feature: feature, created_at: 1.month.ago)
        recent = create(:sortition, feature: feature)

        visit_feature

        expect(page).to have_selector("#sortitions .card-grid .column:first-child", text: recent.title[:en])
        expect(page).to have_selector("#sortitions .card-grid .column:last-child", text: older.title[:en])
      end
    end

    context "when paginating" do
      let!(:collection) { create_list :sortition, collection_size, feature: feature }
      let!(:resource_selector) { ".card--sortition" }

      it_behaves_like "a paginated resource"
    end
  end
end
