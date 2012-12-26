Sixlock::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => 'sixlock#who_is_it_for'

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  resources :records, :except => [:index, :new]
  resources :folders, :except => [:show, :new, :index]

  match 'home' => 'home#index', :as => :home, :via => :get

  match 'who-is-it-for' => 'sixlock#who_is_it_for', :as => :who_is_it_for, :via => :get
  match 'features' => 'sixlock#features', :as => :features, :via => :get
end
