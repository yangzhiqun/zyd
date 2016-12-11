# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(spdata1.js spdata2.js spdata3.js spdata4.js spdata5.js spdata6.js spdata7.js spdata8.js spdata10.js deploy.js XTXSuite.js  XTXSAB.js ESealWebSocket.js login.css tasks.css print.css)
