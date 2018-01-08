# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Sortitions
    module Admin
      describe ParticipatorySpaceProposalFeatures do
        let(:organization) { create(:organization) }
        let(:participatory_process) { create(:participatory_process, organization: organization) }
        let(:proposal_features) { create_list(:proposal_feature, 10, participatory_space: participatory_process) }
        let(:unpublished_proposal_features) { create_list(:proposal_feature, 10, participatory_space: participatory_process, published_at: nil) }
        let(:sortition_features) { create_list(:sortition_feature, 10, participatory_space: participatory_process) }

        it "returns proposal features in the participatory space" do
          expect(described_class.for(participatory_process)).to include(*proposal_features)
        end

        it "Do not include unpublished proposal features" do
          expect(described_class.for(participatory_process)).not_to include(*unpublished_proposal_features)
        end

        it "do not return other features in participatory space" do
          expect(described_class.for(participatory_process)).not_to include(*sortition_features)
        end
      end
    end
  end
end
