# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Module
    module Sortitions
      module Admin
        describe CreateSortition do
          let(:organization) { create(:organization) }
          let(:author) { create(:user, :admin, organization: organization) }
          let(:participatory_process) { create(:participatory_process, organization: organization) }
          let(:proposal_feature) { create(:proposal_feature, participatory_space: participatory_process) }
          let(:dice) { ::Faker::Number.between(1, 6) }
          let(:target_items) { ::Faker::Number.number(2) }
          let(:witnesses) { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
          let(:additional_info) { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }

          let(:params) do
            {
              decidim_proposals_feature_id: proposal_feature.id,
              decidim_category_id: nil,
              dice: dice,
              target_items: target_items,
              witnesses: witnesses,
              additional_info: additional_info
            }
          end

          let(:sortition_feature) { create(:sortition_feature, participatory_space: participatory_process) }

          let(:context) do
            {
              current_feature: sortition_feature,
              current_user: author
            }
          end

          let(:form) { SortitionForm.from_params(sortition: params).with_context(context) }
          let(:command) { described_class.new(form) }

          describe "when the form is not valid" do
            before do
              expect(form).to receive(:invalid?).and_return(true)
            end

            it "broadcasts invalid" do
              expect { command.call }.to broadcast(:invalid)
            end

            it "doesn't create the sortition" do
              expect do
                command.call
              end.to change { Sortition.where(feature: sortition_feature).count }.by(0)
            end
          end

          describe "when the form is valid" do
            let!(:proposals) do
              create_list(:proposal, target_items.to_i,
                          feature: proposal_feature,
                          created_at: Time.now.utc - 1.day)
            end

            before do
              expect(form).to receive(:invalid?).and_return(false)
            end

            it "broadcasts ok" do
              expect { command.call }.to broadcast(:ok)
            end

            it "Creates a sortition" do
              expect do
                command.call
              end.to change { Sortition.where(feature: sortition_feature).count }.by(1)
            end

            it "The created sortition contains a list of selected proposals" do
              command.call
              sortition = Sortition.where(feature: sortition_feature).last
              expect(sortition.selected_proposals).not_to be_empty
            end
          end
        end
      end
    end
  end
end
