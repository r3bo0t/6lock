Sixlock::Application.routes.draw do
  mount RailsAdmin::Engine => '/openthegates', :as => 'rails_admin'

  root :to => 'sixlock#who_is_it_for'

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  resources :records, :except => [:index, :new] do
    collection do
      get 'export', :defaults => { :format => 'csv' }
      post 'set_favorite'
    end
    member do
      get 'delete_favorite'
    end
  end

  resources :folders, :except => [:show, :new, :index]

  match 'home' => 'home#index', :as => :home, :via => :get

  match 'who-is-it-for' => 'sixlock#who_is_it_for', :as => :who_is_it_for, :via => :get
  match 'features' => 'sixlock#features', :as => :features, :via => :get
  match 'security' => 'sixlock#security', :as => :security, :via => :get
  match 'user-agreement' => 'sixlock#user_agreement', :as => :user_agreement, :via => :get
end
