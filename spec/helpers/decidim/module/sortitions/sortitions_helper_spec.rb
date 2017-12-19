# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Module
    module Sortitions
      describe SortitionsHelper do
        describe "proposal_path" do
          let(:proposal) { create(:proposal) }

          it "Returns a path for a proposal" do
            expect(helper.proposal_path(proposal)).not_to be_blank
          end
        end
      end
    end
  end
end
