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
    match "/myvoyce(/:filter(/:sort(/:page(/:barcode))))" => :index, :as => :myvoyce
    match "/logout" => :logout, :as => :logout
  end

  match "/ourvoyce/vote" => "ourvoyce#vote", :as => :current_question_vote
  match "/ourvoyce" => "ourvoyce#index", :as => :ourvoyce

  controller :stats do
    match "/stats(/:action)", :defaults => {:action => "index"}
  end

  match "/log" => "error_logs#index", :as => :error_log

	namespace :admin do
		resources :states, :corporations, :users, :products, :medias, :governments
	end

  resources :current_questions

	#resources :account, :only => [:create, :update, :edit]

  match "/corporate/vote" => "corporates#vote", :as => :corporate_vote
	match "/corporate(/:filter(/:sort(/:page(/:id))))" => "corporates#index", :as => :corporates_index

  match "/products/vote" => "products#vote", :as => :product_vote

  match "/media/vote" => "medias#vote", :as => :media_vote
	match "/media(/:media_type(/:network(/:filter(/:sort(/:page(/:id))))))" => "medias#index", :as => :media_index

  match "/government/vote" => "governments#vote", :as => :government_vote
	match '/government' => 'governments#index', :as => :government_index
	scope "/government" do
		match 'executive(/:sort(/:id))' => 'governments#executive', :as => :executive, :defaults => {:sort => ''}
		match 'legislative/:state(/:sort(/:id))' => 'governments#legislative', :as => :legislative
		match 'legislative_state(/:sort(/:id))' => 'governments#legislative_state', :as => :legislative_state
		match 'agency(/:filter(/:sort(/:page(/:id))))' => 'governments#agency', :as => :agency
	end

	match "services/website/corporate/map/:corporation_id" => "services#corporate_map_all"
	match "services/website/corporate/map/:corporation_id/:state" => "services#corporate_map_state"
	match "services/website/corporate/age/:corporation_id" => "services#corporate_age_all"
	match "services/website/corporate/age/:corporation_id/:state" => "services#corporate_age_state"

	match "services/website/government/map/:government_id" => "services#government_map_all"
	match "services/website/government/map/:government_id/:state" => "services#government_map_state"
	match "services/website/government/age/:government_id" => "services#government_age_all"
	match "services/website/government/age/:government_id/:state" => "services#government_age_state"

	match "services/website/legislativestate/map/:state_id" => "services#legislative_state_map_all"
	match "services/website/legislativestate/map/:state_id/:state" => "services#legislative_state_map_state"
	match "services/website/legislativestate/age/:state_id" => "services#legislative_state_age_all"
	match "services/website/legislativestate/age/:state_id/:state" => "services#legislative_state_age_state"

	match "services/website/media/map/:media_id" => "services#media_map_all"
	match "services/website/media/map/:media_id/:state" => "services#media_map_state"
	match "services/website/media/age/:media_id" => "services#media_age_all"
	match "services/website/media/age/:media_id/:state" => "services#media_age_state"

	match "services/website/mediatype/map/:media_type_id" => "services#media_type_map_all"
	match "services/website/mediatype/map/:media_type_id/:state" => "services#media_type_map_state"
	match "services/website/mediatype/age/:media_type_id" => "services#media_type_age_all"
	match "services/website/mediatype/age/:media_type_id/:state" => "services#media_type_age_state"

	match "services/website/network/map/:network_id" => "services#network_map_all"
	match "services/website/network/map/:network_id/:state" => "services#network_map_state"
	match "services/website/network/age/:network_id" => "services#network_age_all"
	match "services/website/network/age/:network_id/:state" => "services#network_age_state"

	match "services/website/ourvoyce/age" => "services#ourvoyce_age_all"
	match "services/website/ourvoyce/age/:state" => "services#ourvoyce_age_state"
	match "services/website/ourvoyce/map" => "services#ourvoyce_map_all"
	match "services/website/ourvoyce/map/:state" => "services#ourvoyce_map_state"

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
