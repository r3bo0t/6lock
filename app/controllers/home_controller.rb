class HomeController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_folders_and_records

  def index
    @favorites = Record.often_used(@folders, session[:master])
  end
end
