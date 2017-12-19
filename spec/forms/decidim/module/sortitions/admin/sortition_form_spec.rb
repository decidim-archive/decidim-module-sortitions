# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Module
    module Sortitions
      module Admin
        describe SortitionForm do
          subject { form }

          let(:decidim_proposals_feature_id) { ::Faker::Number.number(10) }
          let(:decidim_category_id) { ::Faker::Number.number(10) }
          let(:dice) { ::Faker::Number.between(1, 6) }
          let(:target_items) { ::Faker::Number.number(2) }
          let(:params) do
            {
              decidim_proposals_feature_id: decidim_proposals_feature_id,
              decidim_category_id: decidim_category_id,
              dice: dice,
              target_items: target_items
            }
          end

          let(:form) { described_class.from_params(params) }

          context "when everything is OK" do
            it { is_expected.to be_valid }
          end

          context "when there is no proposals feature selected" do
            let(:decidim_proposals_feature_id) { nil }

            it { is_expected.to be_invalid }
          end

          context "when there is no category selected" do
            let(:decidim_category_id) { nil }

            it { is_expected.to be_valid }
          end

          context "when there is no dice value selected" do
            let(:dice) { nil }

            it { is_expected.to be_invalid }
          end

          context "when dice value is invalid" do
            let(:dice) { "7" }

            it { is_expected.to be_invalid }
          end

          context "when there is no target items value selected" do
            let(:target_items) { nil }

            it { is_expected.to be_invalid }
          end

          context "when target items value is invalid" do
            let(:target_items) { "0" }

            it { is_expected.to be_invalid }
          end
        end
      end
    end
  end
end
