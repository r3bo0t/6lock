class HomeController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_folders_and_records

  def index
    @often_used = Record.often_used(@folders)
  end
end
