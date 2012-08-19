Sixlock::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => 'sixlock#home'

  devise_for :users

  resources :records, :only => [:show]
  resources :folders, :only => [:create]

  match 'home' => 'home#index', :as => :home, :via => :get
end
