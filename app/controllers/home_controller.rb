class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @folders = current_user.folders
    @current_folder = 0
    @often_used = Record.often_used(@folders)
    @folder = Folder.new
    @record = Record.new
  end
end
