# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Module
    module Sortitions
      describe SortitionSearch do
        let(:feature) { create(:feature, manifest_name: "sortitions") }
        let(:participatory_process) { feature.participatory_space }
        let(:category) { create(:category, participatory_space: participatory_process) }
        let(:sortition) { create(:sortition, feature: feature) }
        let!(:categorization) do
          Decidim::Categorization.create!(decidim_category_id: category.id, categorizable: sortition)
        end

        describe "results" do
          subject do
            described_class.new(
              feature: feature,
              search_text: search_text,
              category_id: category_id
            ).results
          end

          let(:search_text) { nil }
          let(:category_id) { nil }

          it "only includes sortitions from the given feature" do
            other_sortition = create(:sortition)

            expect(subject).to include(sortition)
            expect(subject).not_to include(other_sortition)
          end

          describe "search_text filter" do
            let(:search_text) { "dog" }

            it "returns the sortitions containing the search in the title or the aditional info or or witnesses" do
              create_list(:sortition, 3, feature: feature)
              create(:sortition, title: { en: "A dog" }, feature: feature)
              create(:sortition, additional_info: { en: "There is a dog in the office" }, feature: feature)
              create(:sortition, witnesses: { en: "My dog was there" }, feature: feature)

              expect(subject.size).to eq(3)
            end
          end

          describe "category_id filter" do
            let(:category_id) { category.id }

            it "Returns sortitions with the given category" do
              create_list(:sortition, 3, feature: feature)

              expect(subject.size).to eq(1)
            end
          end
        end
      end
    end
  end
end
