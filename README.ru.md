# GemsAssetsWebpackBridge

Рельсовый гем, который помогает построить мост между ассетами в руби гемах и [Вебпаком](https://webpack.js.org/).

![pexels-photo-208684](https://user-images.githubusercontent.com/496713/36936816-18261a9c-1f1b-11e8-9c46-6b6d830fed2c.jpeg)

## Проблема

1. У меня было классическое монолитное рельсовое приложение со Sprockets.
2. Я разделил приложение на несколько рельсовых гемов и перенес в них ассеты.
3. Я начал миграцию со Sprockets на Webpack.
4. Webpack ничего не знал о путях к ассетах в моих рельсовых гемах.

## Решение

Этот гем помогает собрать пути к ассетам в руби гемах и сделать [ссылки (алиасы)](https://webpack.js.org/configuration/resolve/#resolve-alias) для Вебпака, чтобы он мог найти ассеты в руби гемах.

## Установка

**Gemfile**

```ruby
gem 'gems_assets_webpack_bridge'
```

```
$ bundle
```

## Использование

Создать мост между рельсовыми гемами и Вебпаком:

```ruby
rake gems_asstes_webpack_bridge:create
```

### Что такое Мост?

* Мост это JSON файл с путями к папкам ассетов в ваших руби гемах.
* Мост формирует [ссылки (алиасы)](https://webpack.js.org/configuration/resolve/#resolve-alias) для Вебпака, чтобы помочь ему найти ваши ассеты.
* Каждая ссылка имеет следующий формат: `@[UNDERSCORED_GEM_NAME]-[ASSET_TYPE]`.
* Типы ассетов по умолачнию: `images`, `scripts`, `styles`.
* Имя файла-моста по-умолчанию `gems-assets-webpack-bridge.json` и выглядит он примерно так:

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

### Как использовать Мост?

Теперь, когда у вас есть файл-мост, вы можете использовать его в конфиге Вебпака:

**webpack.config.js**

```javascript
// Эта функция читает файл-мост
// И добавляет ссылки в `WebPackConfig.resolve.alias`
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

После того, как вы добавили ссылки в Вебпак, вы можете использовать их в энтри-поинтах:

```javascript
require('@log_js-scripts/log_js')
require('@notifications-scripts/notifications')
require('@the_comments-scripts/the_comments')

require('@notifications-styles/notifications')
require('@the_comments-styles/the_comments')
```

### Как я могу сконфигурировать этот гем?

 Создайте инициализатор в приложении и вы сможете настроить следующие значения:

**config/initializers/gems_assets_webpack_bridge.rb**

```ruby
GemsAssetsWebpackBridge.configure do |config|
  # От корня рельсового приложения
  config.bridge_path = '/configs/gems-webpack-bridge.json'

  # От корня любого гема
  config.assets_types = {
    # Значения по-умолчанию
    images: 'app/assets/images',
    scripts: 'app/assets/javascripts',
    styles: 'app/assets/stylesheets',

    # Ваши кастомные пути
    vendor_select2_images: 'vendors/select2/images',
  }
end
```

### Нужно ли мне добавлять файл-мост в мою систему контроля версий?

Нет. Пути будут у всех разные. Просто добавьте `gems-assets-webpack-bridge.json` в ваш  `.gitignre` и запускайте `rake gems_asstes_webpack_bridge:create` когда вам это потребуется.

### Нужно ли мне поменять процесс деплоя?

Вам нужно запускать `rake gems_asstes_webpack_bridge:create` перед каждой компиляцией Вебпака во время деплоя. Иначе Вебпак не будет ничего знать о дополнительных ссылках и компиляция не будет работать.

### License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[Bridge image @ pexels.com](https://www.pexels.com/photo/architecture-autumn-blue-blue-sky-208684/)
