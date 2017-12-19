# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      class ApplicationRecord < ActiveRecord::Base
        self.abstract_class = true
      end
    end
  end
end
