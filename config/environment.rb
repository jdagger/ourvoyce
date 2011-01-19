#ENV['GEM_PATH'] = File.expand_path('~/.gems') + ':/usr/lib/ruby/gems/1.8'

# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
Production::Application.initialize!

Rails.configuration.autoload_paths += %W(#{Rails.root.to_s}/app/presenters)
Rails.configuration.autoload_paths += %W(#{Rails.root.to_s}/app/services)
Rails.configuration.autoload_paths += %W(#{Rails.root.to_s}/app/mixins)
Rails.configuration.autoload_paths += %W(#{Rails.root.to_s}/lib)

Rails.configuration.logos_domain = "http://www.directeddata.com"
#Rails.configuration.logos_domain = "http://localhost:3000"

