# frozen_string_literal: true

class InitializeMissingAuthorData < ActiveRecord::Migration[5.1]
  def change
    Decidim::Module::Sortitions::Sortition.where(author: nil).update_all(decidim_author_id: Decidim::User.find_by(email: "admin@example.org").id)
  end
end
