# frozen_string_literal: true

Decidim.register_feature(:sortitions) do |feature|
  feature.engine = Decidim::Module::Sortitions::Engine
  feature.admin_engine = Decidim::Module::Sortitions::AdminEngine
  feature.icon = "decidim/module/sortitions/icon.svg"
  feature.stylesheet = "decidim/module/sortitions/sortitions"

  feature.on(:before_destroy) do |instance|
    if Decidim::Module::Sortitions::Sortition.where(feature: instance).any?
      raise StandardError, "Can't remove this feature"
    end
  end

  # These actions permissions can be configured in the admin panel
  feature.actions = %w()

  # feature.settings(:global) do |settings|
  # end

  # feature.settings(:step) do |settings|
  # end

  # # Register an optional resource that can be referenced from other resources.
  # feature.register_resource do |resource|
  #   resource.model_class_name = "Decidim::<EngineName>::<ResourceName>"
  #   resource.template = "decidim/<engine_name>/<resource_view_folder>/linked_<resource_name_plural>"
  # end

  feature.register_stat :some_stat do |features, start_at, end_at|
    # Register some stat number to the application
  end

  feature.seeds do |participatory_space|
    feature = Decidim::Feature.create!(
      name: Decidim::Features::Namer.new(participatory_space.organization.available_locales, :sortitions).i18n_name,
      manifest_name: :sortitions,
      published_at: Time.current,
      participatory_space: participatory_space
    )
  end
end
