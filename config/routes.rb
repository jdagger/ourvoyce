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

  match "/login" => "users#login", :as => :login
  match "/logout" => "users#logout", :as => :logout
  match "/account" => "users#edit", :as => :edit_account
  match "/save_account" => "users#update", :as => :update_account
  match "/register" => "users#new", :as => :register
  match "/create_account" => "users#create", :as => :create_account
  match "/myvoyce(/:filter(/:sort(/:page(/:barcode))))" => "users#show", :as => :myvoyce
  resources :reset_passwords


  match "/ourvoyce/vote" => "ourvoyce#vote", :as => :current_question_vote
  match "/ourvoyce" => "ourvoyce#index", :as => :ourvoyce

  controller :stats do
    match "/stats(/:action)", :defaults => {:action => "index"}
  end

  match "/log" => "error_logs#index", :as => :error_log

  namespace :admin do
    match 'products/filter/:filter' => 'products#index'
    match 'users/filter/:filter' => 'users#index'
    resources :states, :corporations, :users, :products, :medias, :governments
  end

  resources :current_questions

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


  root :to => "ourvoyce#index"
end
