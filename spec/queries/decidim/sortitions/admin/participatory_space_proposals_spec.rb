# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Sortitions
    module Admin
      describe ParticipatorySpaceProposals do
        let(:organization) { create(:organization) }
        let(:participatory_process) { create(:participatory_process, organization: organization) }
        let(:proposal_feature) { create(:proposal_feature, participatory_space: participatory_process) }
        let(:another_proposal_feature) { create(:proposal_feature, participatory_space: participatory_process) }
        let(:proposals) { create_list(:proposal, 10, feature: proposal_feature, created_at: request_timestamp - 10.days) }
        let(:request_timestamp) { Time.now.utc }
        let(:category) { nil }
        let(:decidim_proposals_feature) { proposal_feature }
        let(:sortition) do
          double(
            request_timestamp: request_timestamp,
            category: category,
            decidim_proposals_feature: decidim_proposals_feature
          )
        end

        context "when filtering by feature" do
          let(:other_feature_proposals) { create_list(:proposal, 10, feature: another_proposal_feature) }

          it "Includes only proposals in this feature" do
            expect(described_class.for(sortition)).to include(*proposals)
          end

          it "Do not includes proposals in other features" do
            expect(described_class.for(sortition)).not_to include(*other_feature_proposals)
          end
        end

        context "when filtering by creation date" do
          let(:recent_proposals) { create_list(:proposal, 10, feature: proposal_feature, created_at: Time.now.utc) }
          let(:request_timestamp) { Time.now.utc - 1.day }

          it "Includes proposals created before the sortition date" do
            expect(described_class.for(sortition)).to include(*proposals)
          end

          it "Do not includes proposals created after the sortition date" do
            expect(described_class.for(sortition)).not_to include(*recent_proposals)
          end
        end

        context "when filtering by category" do
          let(:proposal_category) { create(:category, participatory_space: participatory_process) }
          let(:proposals_with_category) do
            create_list(:proposal, 10,
                        feature: proposal_feature,
                        category: proposal_category,
                        created_at: request_timestamp - 10.days)
          end

          context "and category is passed nil" do
            it "Contains all proposals" do
              expect(described_class.for(sortition)).to include(*proposals)
              expect(described_class.for(sortition)).to include(*proposals_with_category)
            end
          end

          context "and category is passed" do
            let(:category) { proposal_category }

            it "Contains proposals of the category" do
              expect(described_class.for(sortition)).to include(*proposals_with_category)
            end

            it "Do not contains proposals of the category" do
              expect(described_class.for(sortition)).not_to include(*proposals)
            end
          end
        end
      end
    end
  end
end
