require 'json'

# rake gems_assets_webpack_bridge:create
namespace :gems_assets_webpack_bridge do
  task create: :environment do
    assets_types = GemsAssetsWebpackBridge.config.assets_types
    bridge_path = GemsAssetsWebpackBridge.config.bridge_path

    bridge = Bundler.load.specs.inject({}) do |bridge, gem|
      assets_types.each do |type_name, type_path|
        assets_path = "#{gem.full_gem_path}/#{type_path}"

        if Dir.exist?(assets_path)
          path_name = "@#{gem.name.underscore}-#{type_name}"
          bridge[path_name] = assets_path
        end
      end

      bridge
    end

    bridge_file = "#{Rails.root}/#{bridge_path}"
    File.open(bridge_file, 'w') do |file|
      file.write JSON.pretty_generate(bridge)
    end

    puts "GemsAssetsWebpackBridge"
    puts "The bridge-file is created: #{bridge_file}"
  end
end
