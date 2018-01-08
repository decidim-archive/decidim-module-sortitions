# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Sortitions
    module Admin
      describe SortitionsHelper do
        describe "features_options" do
          let(:features) { [double(id: 1, name: { "en" => "Feature name" })] }

          it "Returns a list of selectable features" do
            expect(helper.features_options(features)).to include(["Feature name", 1])
          end
        end

        describe "sortition_category" do
          let(:sortition) { double(category: category) }

          context "when category is null" do
            let(:category) { nil }

            it "Returns all categories" do
              expect(helper.sortition_category(sortition)).to eq("All categories")
            end
          end

          context "when category is not null" do
            let(:category) { double(name: { "en" => "Category name" }) }

            it "Returns the category name" do
              expect(helper.sortition_category(sortition)).to eq("Category name")
            end
          end
        end
      end
    end
  end
end
