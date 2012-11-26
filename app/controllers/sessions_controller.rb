class SessionsController < Devise::SessionsController
  def create
    session[:master] = params[:user][:password]
    super
  end
end