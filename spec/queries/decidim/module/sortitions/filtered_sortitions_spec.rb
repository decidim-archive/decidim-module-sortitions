# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Module
    module Sortitions
      describe FilteredSortitions do
        let(:organization) { create(:organization) }
        let(:feature) { create(:sortition_feature, organization: organization) }
        let(:other_feature) { create(:sortition_feature) }
        let!(:sortitions) { create_list(:sortition, 10, feature: feature) }

        it "Includes all sortitions for the given feature" do
          expect(described_class.for(feature)).to include(*sortitions)
        end

        it "Do not includes sortitios from other features" do
          expect(described_class.for(other_feature)).not_to include(*sortitions)
        end
      end
    end
  end
end
