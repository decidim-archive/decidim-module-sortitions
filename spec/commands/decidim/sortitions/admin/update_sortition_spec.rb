# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Sortitions
    module Admin
      describe UpdateSortition do
        let(:additional_info) { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
        let(:title) { Decidim::Faker::Localized.sentence(3) }
        let(:sortition) { create(:sortition) }
        let(:params) do
          {
            id: sortition.id,
            sortition: {
              title: title,
              additional_info: additional_info
            }
          }
        end

        let(:context) do
          {
            current_feature: sortition.feature
          }
        end

        let(:form) { EditSortitionForm.from_params(params).with_context(context) }
        let(:command) { described_class.new(form) }

        describe "when the form is not valid" do
          before do
            expect(form).to receive(:invalid?).and_return(true)
          end

          it "broadcasts invalid" do
            expect { command.call }.to broadcast(:invalid)
          end
        end

        describe "when the form is valid" do
          before do
            expect(form).to receive(:invalid?).and_return(false)
          end

          it "broadcasts ok" do
            expect { command.call }.to broadcast(:ok)
          end

          it "Updates the title" do
            command.call
            sortition.reload
            expect(sortition.title).to eq(title)
          end

          it "Updates the additional info" do
            command.call
            sortition.reload
            expect(sortition.additional_info).to eq(additional_info)
          end
        end
      end
    end
  end
end
