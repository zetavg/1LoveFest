##
# Bower
##

@bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
ignore @bower_config["directory"].gsub(/source\//, "") + '/*'

###
# Compass
###

# Change Compass configuration
compass_config do |config|
  # Require additional compass plugins.
  config.add_import_path @bower_config["directory"].gsub(/source\//, "") + "/Han/sass"
  config.add_import_path @bower_config["directory"].gsub(/source\//, "") + "/foundation/scss"
  config.add_import_path @bower_config["directory"].gsub(/source\//, "") + "/susy/sass"

  # config.output_style = :compact
end

###
# Page options, layouts, aliases and proxies
###

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Template Engine Options
###

set :haml, { :attr_wrapper => '"', :format => :html5 }

require 'slim'
set :slim, :pretty => true

###
# Helpers
###

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload, :port => 35732, :apply_css_live => true
end

activate :directory_indexes

# Add bower's directory to sprockets asset path
sprockets.append_path File.join "#{root}", @bower_config["directory"]

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # Change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # activate :imageoptim

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets
end
