# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Sortitions
    module Admin
      describe DestroySortition do
        let(:organization) { create(:organization) }
        let(:admin) { create(:user, :admin, organization: organization) }
        let(:participatory_process) { create(:participatory_process, organization: organization) }
        let(:sortition_feature) { create(:sortition_feature, participatory_space: participatory_process) }
        let(:sortition) { create(:sortition, feature: sortition_feature) }
        let(:cancel_reason) do
          Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) }
        end

        let(:params) do
          {
            id: sortition.id,
            sortition: {
              cancel_reason: cancel_reason
            }
          }
        end

        let(:context) do
          {
            current_feature: sortition_feature,
            current_user: admin
          }
        end

        let(:form) { DestroySortitionForm.from_params(sortition: params).with_context(context) }
        let(:command) { described_class.new(form) }

        describe "when the form is not valid" do
          before do
            expect(form).to receive(:invalid?).and_return(true)
          end

          it "broadcasts invalid" do
            expect { command.call }.to broadcast(:invalid)
          end

          it "doesn't cancel the sortition" do
            command.call
            sortition.reload
            expect(sortition).not_to be_cancelled
          end
        end

        describe "when the form is valid" do
          before do
            expect(form).to receive(:invalid?).and_return(false)
          end

          it "broadcasts ok" do
            expect { command.call }.to broadcast(:ok)
          end

          it "Cancels the sortition" do
            command.call
            sortition.reload
            expect(sortition).to be_cancelled
          end

          it "Data from the user who cancelled the sortition is stored" do
            command.call
            sortition.reload
            expect(sortition.cancelled_by_user).to eq(admin)
          end
        end
      end
    end
  end
end
