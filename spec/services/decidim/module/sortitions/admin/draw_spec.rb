# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Module
    module Sortitions
      module Admin
        describe Draw do
          let(:organization) { create(:organization) }
          let(:participatory_process) { create(:participatory_process, organization: organization) }
          let(:proposal_feature) { create(:proposal_feature, participatory_space: participatory_process) }
          let(:target_items) { ::Faker::Number.number(2).to_i }
          let(:seed) { Time.now.utc.to_i * ::Faker::Number.between(1, 6).to_i }
          let!(:proposals) do
            create_list(:proposal, target_items * 2,
                        feature: proposal_feature,
                        created_at: Time.now.utc - 1.day)
          end
          let(:sortition) do
            double(
              target_items: target_items,
              seed: seed,
              category: nil,
              request_timestamp: Time.now.utc,
              decidim_proposals_feature: proposal_feature
            )
          end

          it "Draw can be reproduced several times" do
            expect(Draw.for(sortition)).to eq(Draw.for(sortition))
          end
        end
      end
    end
  end
end
