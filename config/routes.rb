Production::Application.routes.draw do

  controller :site do
    match "/help" => :help
    match "/privacy" => :privacy
    match "/terms" => :terms
    match "/donate" => :donate
    match "/about" => :about
    match "/contact" => :contact
    match "/iphone" => :iphone
    match "/members" => :members
    match "/how-does-this-work" => :help
    #match "/idol" => :idol
    #match "/mcdonalds" => :mcdonalds
    #match "/starbucks" => :starbucks
  end


  #SSL protected
  #Need to update config/environements/production.rb if change any of these routes
  match "/login" => "users#login", :as => :login
  match "/register" => "users#new", :as => :register
  match "/account" => "users#edit", :as => :edit_account
  match "/save_account" => "users#update", :as => :update_account
  match "/create_account" => "users#create", :as => :create_account
  resources :reset_passwords
  #END SSL protected

  match "/logout" => "users#logout", :as => :logout
  match "/verify(/:id)" => "users#verify", :as => :verify
  match "/request_username" => "users#request_username", :as => :request_username
  match "/myvoyce(/:filter(/:sort(/:page(/:barcode))))" => "users#show", :as => :myvoyce


  match "/ourvoyce/vote" => "ourvoyce#vote", :as => :current_question_vote
  match "/" => "ourvoyce#index", :as => :ourvoyce

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

  match "services/website/product/map/:product_id" => "services#product_map_all"
  match "services/website/product/map/:product_id/:state" => "services#product_map_state"
  match "services/website/product/age/:product_id" => "services#product_age_all"
  match "services/website/product/age/:product_id/:state" => "services#product_age_state"

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


  #Constrain on numbers only (UPC lookups)
  match "/:id" => "products#lookup", :as => :product_lookup, :constraints => {:id => /\d+/}

  #match "/ov/:id" => "products#lookup", :as => :product_lookup
  match "/:id" => "products#category", :as => :product_category

  root :to => "ourvoyce#index"
end
