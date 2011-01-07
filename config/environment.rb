#ENV['GEM_PATH'] = File.expand_path('~/.gems') + ':/usr/lib/ruby/gems/1.8'

# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
Production::Application.initialize!

Rails.configuration.load_paths += %W(#{RAILS_ROOT}/app/presenters)
Rails.configuration.load_paths += %W(#{RAILS_ROOT}/app/services)
Rails.configuration.load_paths += %W(#{RAILS_ROOT}/lib)
