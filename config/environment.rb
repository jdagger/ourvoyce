#ENV['GEM_PATH'] = File.expand_path('~/.gems') + ':/usr/lib/ruby/gems/1.8'

# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
Production::Application.initialize!

Rails.configuration.autoload_paths += %W(#{Rails.root.to_s}/lib)

Rails.configuration.logos_domain = "https://s3.amazonaws.com/ourvoYce"
Rails.configuration.default_page_size = 50
