# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Module
    module Sortitions
      module Admin
        describe SortitionsController, type: :controller do
          routes { Decidim::Module::Sortitions::AdminEngine.routes }

          let(:feature) { sortition.feature }
          let(:sortition) { create(:sortition) }
          let(:user) { create(:user, :confirmed, :admin, organization: feature.organization) }

          before do
            request.env["decidim.current_organization"] = feature.organization
            request.env["decidim.current_feature"] = feature
            sign_in user, scope: :user
          end

          describe "show" do
            let(:sortition) { create(:sortition) }
            let(:params) do
              {
                feature_id: sortition.feature.id,
                participatory_process_slug: sortition.feature.participatory_space.slug,
                id: sortition.id
              }
            end

            it "renders the show template" do
              get :show, params: params
              expect(response).to render_template(:show)
            end
          end

          describe "new" do
            let(:params) do
              { participatory_process_slug: feature.participatory_space.slug }
            end

            it "renders the new template" do
              get :new, params: params
              expect(response).to render_template(:new)
            end
          end

          describe "create" do
            let(:decidim_category_id) { nil }
            let(:dice) { ::Faker::Number.between(1, 6) }
            let(:target_items) { ::Faker::Number.between(1, 10) }
            let(:params) do
              {
                participatory_process_slug: feature.participatory_space.slug,
                sortition: {
                  decidim_proposals_feature_id: decidim_proposals_feature_id,
                  decidim_category_id: decidim_category_id,
                  dice: dice,
                  target_items: target_items,
                  witnesses: {
                    en: "Witnesses",
                    es: "Testigos",
                    ca: "Testimonis"
                  },
                  additional_info: {
                    en: "Additional information",
                    es: "Información adicional",
                    ca: "Informació adicional"
                  }
                }
              }
            end

            context "with invalid params" do
              let(:decidim_proposals_feature_id) { nil }

              it "renders the new template" do
                post :create, params: params
                expect(response).to render_template(:new)
              end
            end

            context "with valid params" do
              let(:proposal_feature) { create(:proposal_feature, participatory_space: feature.participatory_space) }
              let(:decidim_proposals_feature_id) { proposal_feature.id }

              it "redirects to show newly created sortition" do
                post :create, params: params
                expect(response).to redirect_to action: :show,
                                                feature_id: Sortition.last.feature.id,
                                                participatory_process_slug: Sortition.last.feature.participatory_space.slug,
                                                id: Sortition.last.id
              end

              it "Sortition author is the current user" do
                post :create, params: params
                expect(Sortition.last.author).to eq(user)
              end
            end
          end
        end
      end
    end
  end
end
