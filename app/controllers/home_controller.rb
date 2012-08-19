class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @folders = current_user.folders
    @often_used = Record.often_used(@folders)
    @folder = Folder.new
  end
end
