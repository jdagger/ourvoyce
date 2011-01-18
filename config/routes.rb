Production::Application.routes.draw do

	controller :myvoyce do
		get 'myvoyce' => :show
	end

	controller :sessions do
		get 'login' => :new
		post 'login' => :create
		get 'logout' => :destroy
	end

	namespace :admin do
		resources :states, :corporations, :users, :products
	end

	controller :account do
		get 'signup' => :new
		post 'signup' => :create, :as => :create_account
	end

	resources :account, :only => [:create, :update, :edit]

	# Corporate Index Routes
  match "/corporate/vote" => "corporates#vote", :as => :corporate_vote
	match "/corporate/:filter/:sort/:offset" => "corporates#index"
	match "/corporate/:filter/:sort" => "corporates#index", :offset => "0"
	match "/corporate" => "corporates#index", :as => :corporates_index

	#End Corporate Routes

  match "/products/vote" => "products#vote", :as => :product_vote
	match "/products/lookup" => "products#lookup"

  match "/media/vote" => "medias#vote", :as => :media_vote
	match "/media(/:type(/:network))" => "medias#index", :as => :media_index

  match "/government/vote" => "governments#vote", :as => :government_vote
	match '/government' => 'governments#index', :as => :government_index
	scope "/government" do
		match 'executive' => 'governments#executive', :as => :executive
		match 'legislative(/:state)' => 'governments#legislative', :as => :legislative
		match 'agency' => 'governments#agency', :as => :agency
	end

	# Product Index Routes
	match "/products/:offset" => "products#index"
	match "/products" => "products#index", :offset => "0"
	#End Product Routes

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
