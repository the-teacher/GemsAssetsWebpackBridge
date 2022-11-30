# GemsAssetsWebpackBridge

This Rails gem helps to build a bridge from assets in your ruby gems to [Webpack](https://webpack.js.org/).

![pexels-photo-208684](https://user-images.githubusercontent.com/496713/36936816-18261a9c-1f1b-11e8-9c46-6b6d830fed2c.jpeg)

## The Problem

1. I had a classic monolith Rails application with Sprockets.
2. I've split my Rails app into a few Rails gems and moved my assets into gems.
3. I started migration from Sprockets to Webpack.
4. Webpack didn't know how to find my assets in Rails gems.

## The Solution

This gem helps to collect paths to assets' folders in gems and adds some [aliases](https://webpack.js.org/configuration/resolve/#resolve-alias) for Webpack to help it to find assets in classic Rails gems.

## Installation

**Gemfile**

```ruby
gem 'gems_assets_webpack_bridge'
```

```
$ bundle
```

## Usage

Build a bridge between Rails gems and Webpack:

```ruby
rake gems_assets_webpack_bridge:build
```

### What is The Bridge?

* The Bridge is a JSON file with paths to assets in your gems.
* The Bridge provides additional [aliases](https://webpack.js.org/configuration/resolve/#resolve-alias) for Webpack to help it to find assets' folders in ruby gems.
* Every alias has the following naming: `@[UNDERSCORED_GEM_NAME]-[ASSET_TYPE]`.
* Default asset types are: `images`, `scripts`, `styles`.
* By default the file has name `gems-assets-webpack-bridge.json` and looks like that:

```json
{
  "@crop_tool-scripts": "/Users/@username/.rvm/gems/ruby-2.4.2/gems/crop_tool/app/assets/javascripts",
  "@crop_tool-styles": "/Users/@username/.rvm/gems/ruby-2.4.2/gems/crop_tool/app/assets/stylesheets",
  "@jquery_ui_rails-images": "/Users/@username/.rvm/gems/ruby-2.3.3@open-cook.ru/gems/jquery-ui-rails-5.0.0/app/assets/images",
  "@jquery_ui_rails-scripts": "/Users/@username/.rvm/gems/ruby-2.3.3@open-cook.ru/gems/jquery-ui-rails-5.0.0/app/assets/javascripts",
  "@jquery_ui_rails-styles": "/Users/@username/.rvm/gems/ruby-2.3.3@open-cook.ru/gems/jquery-ui-rails-5.0.0/app/assets/stylesheets",
  "@log_js-scripts": "/Users/@username/.rvm/gems/ruby-2.4.2/gems/log_js/app/assets/javascripts",
  "@notifications-scripts": "/Users/@username/.rvm/gems/ruby-2.4.2/gems/notifications/app/assets/javascripts",
  "@notifications-styles": "/Users/@username/.rvm/gems/ruby-2.4.2/gems/notifications/app/assets/stylesheets",
}
```

### How to use The Bridge?

Now, when you have the bridge file, you can use it in Webpack like this:

**webpack.config.js**

```javascript
// This helper-function reads the bridge file and
// adds some additional aliases in `WebPackConfig.resolve.alias`
function addGemsAssetsWebpackBridge (WebPackConfig) {
  const alias = WebPackConfig.resolve.alias
  const bridgeFile = `${rootPath}/gems-assets-webpack-bridge.json`

  var bridgeAlias = JSON.parse(fs.readFileSync(bridgeFile, 'utf8'))
  return Object.assign(alias, bridgeAlias)
}

let WebpackConfig = {
  entry: {
    ...
  },

  output: {
    ...
  },

  resolve : {
    alias: {
      '@vendors': `${rootPath}/assets/vendors`
    }
  }
}

WebPackConfig.resolve.alias = addGemsAssetsWebpackBridge(WebPackConfig)
module.exports = WebPackConfig
```

After you added the aliases you can use them in your Webpack entries like this:

```javascript
require('@log_js-scripts/log_js')
require('@notifications-scripts/notifications')
require('@the_comments-scripts/the_comments')

require('@notifications-styles/notifications')
require('@the_comments-styles/the_comments')
```

### How can I configure this gem?

You can create a new initializer in your Rails app change options:

**config/initializers/gems_assets_webpack_bridge.rb**

```ruby
GemsAssetsWebpackBridge.configure do |config|
  # From a root of your Rails app
  config.bridge_path = '/configs/gems-webpack-bridge.json'

  #  From a root of every Rails gem
  config.assets_types = {
    # Default values
    images: 'app/assets/images',
    scripts: 'app/assets/javascripts',
    styles: 'app/assets/stylesheets',

    # Your custom values
    vendor_select2_images: 'vendors/select2/images',
  }
end
```

### Should I add the bridge file in my VCS?

No. Paths will be different for different users. Just add `gems-assets-webpack-bridge.json` in your `.gitignore` and run `rake gems_asstes_webpack_bridge:build` when you need it.

### Should I change my deployment process?

You have to run `rake gems_asstes_webpack_bridge:build` before every Webpack compilation during deployment. Otherwise Webpack will know nothing about aliases and a compilation won't work.

### License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[Bridge image @ pexels.com](https://www.pexels.com/photo/architecture-autumn-blue-blue-sky-208684/)
