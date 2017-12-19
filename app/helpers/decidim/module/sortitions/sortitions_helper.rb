# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      module SortitionsHelper
        def proposal_path(proposal)
          EngineRouter.main_proxy(proposal.feature).proposal_path(proposal)
        end
      end
    end
  end
end
