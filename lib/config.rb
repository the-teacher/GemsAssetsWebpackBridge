module GemsAssetsWebpackBridge
  def self.configure(&block)
    yield @config ||= GemsAssetsWebpackBridge::Configuration.new
  end

  def self.config
    @config
  end

  class Configuration
    include ActiveSupport::Configurable

    config_accessor :assets_types, :bridge_path
  end

  configure do |config|
    config.assets_types = {
      images: 'app/assets/images',
      scripts: 'app/assets/javascripts',
      styles: 'app/assets/stylesheets'
    }

    config.bridge_path = 'gems-assets-webpack-bridge.json'
  end
end
