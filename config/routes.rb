Sixlock::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => 'sixlock#home'

  devise_for :users

  resources :records, :only => [:show]

  get '/home/index'
end
