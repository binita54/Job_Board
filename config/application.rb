require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module JobBoard
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 8.0
    config.load_defaults 8.0

    # Disable API-only mode (required for Devise, views, etc.)
    config.api_only = false
    
    # Autoload configuration
    config.autoloader = :zeitwerk
    config.autoload_lib(ignore: %w[assets tasks])
    config.eager_load_paths << Rails.root.join('app/controllers')

    # Optional: Uncomment if needed
    # config.time_zone = "Your Time Zone (e.g., Kathmandu)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end