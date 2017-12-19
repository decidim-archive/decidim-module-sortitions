# frozen_string_literal: true

shared_examples "manage sortitions" do
  describe "creation" do
    let!(:proposal_feature) do
      create(:proposal_feature, :published, participatory_space: current_feature.participatory_space)
    end

    before do
      visit_feature_admin
    end

    it "can be related to a category" do
      within "form" do
        expect(page).to have_content(/Category/i)
      end
    end

    it "Requires a random number" do
      within "form" do
        expect(page).to have_content(/Dice/i)
      end
    end

    it "Requires the number of proposals to select" do
      within "form" do
        expect(page).to have_content(/Quantity of proposals to select/i)
      end
    end

    it "Requires the proposals feature" do
      within "form" do
        expect(page).to have_content(/Proposals feature/i)
      end
    end

    context "when creates a sortition" do
      let(:sortition_dice) { ::Faker::Number.between(1, 6) }
      let(:sortition_target_items) { ::Faker::Number.between(1, 10) }

      it "shows the sortition details" do
        within ".new_sortition" do
          fill_in :sortition_dice, with: sortition_dice
          fill_in :sortition_target_items, with: sortition_target_items
          select translated(proposal_feature.name), from: :sortition_decidim_proposals_feature_id

          find("*[type=submit]").click
        end

        expect(page).to have_admin_callout("successfully")

        proposal = Decidim::Module::Sortitions::Sortition.last
        within ".sortition" do
          expect(page).to have_content(/Draw time/i)
          expect(page).to have_content(/Dice/i)
          expect(page).to have_content(/Items to select/i)
          expect(page).to have_content(/Category/i)
          expect(page).to have_content(/All categories/i)
          expect(page).to have_content(/Proposals feature/i)
          expect(page).to have_content(translated(proposal_feature.name))
          expect(page).to have_content(/Seed/i)
          expect(page).to have_content(proposal.seed)
          expect(page).to have_content(/Similar sortitions/i)
        end

        within ".proposals" do
          expect(page).to have_content(/Proposals selected for draw/i)
          proposal.selected_proposals.each do |p|
            expect(page).to have_content(translated(p.title))
          end
        end
      end
    end
  end
end
