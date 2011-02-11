Production::Application.routes.draw do

  controller :site do
    match "/help" => :help
    match "/privacy" => :privacy
    match "/terms" => :terms
    match "/donate" => :donate
    match "/about" => :about
    match "/contact" => :contact
    match "/how-does-this-work" => :work
  end

  controller :myvoyce do
    match "/myvoyce/account" => :new
    match "/myvoyce/authenticate" => :authenticate
    match "/myvoyce/create" => :create
    match "/myvoyce(/:filter(/:sort(/:page)))" => :index, :defaults => {:page => 1, :sort => 'name_asc', :filter => ''}, :as => :myvoyce
    match "/logout" => :logout, :as => :logout
  end

  match "/ourvoyce(/:state)" => "ourvoyce#index", :as => :ourvoyce

  controller :stats do
    match "/stats(/:action)", :defaults => {:action => "index"}
  end

  match "/log" => "error_logs#index", :as => :error_log

	namespace :admin do
		resources :states, :corporations, :users, :products, :medias, :governments
	end

	#resources :account, :only => [:create, :update, :edit]

  match "/corporate/vote" => "corporates#vote", :as => :corporate_vote
	match "/corporate(/:filter(/:sort(/:page)))" => "corporates#index", :defaults => {:filter => '', :sort => '', :page => 1}, :as => :corporates_index

  match "/products/vote" => "products#vote", :as => :product_vote

  match "/media/vote" => "medias#vote", :as => :media_vote
	match "/media(/:type(/:network))" => "medias#index", :as => :media_index

  match "/government/vote" => "governments#vote", :as => :government_vote
	match '/government' => 'governments#index', :as => :government_index
	scope "/government" do
		match 'executive' => 'governments#executive', :as => :executive
		match 'legislative(/:state)' => 'governments#legislative', :as => :legislative
		match 'agency(/:filter(/:sort(/:page)))' => 'governments#agency', :defaults => {:filter => '', :sort => '', :page => 1}, :as => :agency
	end

	match "services/website/corporate/map/:corporation_id" => "services#corporate_map_all"
	match "services/website/corporate/map/:corporation_id/:state" => "services#corporate_map_state"
	match "services/website/corporate/age/:corporation_id" => "services#corporate_age_all"
	match "services/website/corporate/age/:corporation_id/:state" => "services#corporate_age_state"
	match "services/:action" => "services#:action"

	root :to => "home#index"

	# The priority is based upon order of creation:
	# first created -> highest priority.

	# Sample of regular route:
	#   match 'products/:id' => 'catalog#view'
	# Keep in mind you can assign values other than :controller and :action

	# Sample of named route:
	#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
	# This route can be invoked with purchase_url(:id => product.id)

	# Sample resource route (maps HTTP verbs to controller actions automatically):
	#   resources :products

	# Sample resource route with options:
	#   resources :products do
	#     member do
	#       get 'short'
	#       post 'toggle'
	#     end
	#
	#     collection do
	#       get 'sold'
	#     end
	#   end

	# Sample resource route with sub-resources:
	#   resources :products do
	#     resources :comments, :sales
	#     resource :seller
	#   end

	# Sample resource route with more complex sub-resources
	#   resources :products do
	#     resources :comments
	#     resources :sales do
	#       get 'recent', :on => :collection
	#     end
	#   end

	# Sample resource route within a namespace:
	#   namespace :admin do
	#     # Directs /admin/products/* to Admin::ProductsController
	#     # (app/controllers/admin/products_controller.rb)
	#     resources :products
	#   end

	# You can have the root of your site routed with "root"
	# just remember to delete public/index.html.
	# root :to => "welcome#index"

	# See how all your routes lay out with "rake routes"

	# This is a legacy wild controller route that's not recommended for RESTful applications.
	# Note: This route will make all actions in every controller accessible via GET requests.
	# match ':controller(/:action(/:id(.:format)))'

end
