Sixlock::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "sixlock#home"

  devise_for :users
  resources :users, :only => [:show, :index]

  resources :files, :only => [:show]
end
