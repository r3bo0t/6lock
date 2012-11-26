Sixlock::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => 'sixlock#home'

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  resources :records, :except => [:index, :new]
  resources :folders, :except => [:show, :new, :index]

  match 'home' => 'home#index', :as => :home, :via => :get
end
