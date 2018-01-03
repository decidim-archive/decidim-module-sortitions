# frozen_string_literal: true

class InitializeMissingAuthorData < ActiveRecord::Migration[5.1]
  def change
    admin_id = Decidim::User.find_by(email: "admin@example.org")&.id
    Decidim::Module::Sortitions::Sortition.where(author: nil).update_all(decidim_author_id: admin_id) unless admin_id.nil?
  end
end
