# frozen_string_literal: true

Decidim.register_feature(:sortitions) do |feature|
  feature.engine = Decidim::Sortitions::Engine
  feature.admin_engine = Decidim::Sortitions::AdminEngine
  feature.icon = "decidim/sortitions/icon.svg"
  feature.stylesheet = "decidim/sortitions/sortitions"

  feature.on(:before_destroy) do |instance|
    if Decidim::Sortitions::Sortition.where(feature: instance).any?
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

  feature.register_stat :sortitions_count, primary: true, priority: Decidim::StatsRegistry::HIGH_PRIORITY do |features, start_at, end_at|
    Decidim::Sortitions::FilteredSortitions.for(features, start_at, end_at).count
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
