class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :prepare_folders_and_records

  def after_sign_in_path_for(resource)
    home_path
  end

  private
    def prepare_folders_and_records
      @folders = current_user.folders
      @folder = Folder.new
      @record = Record.new
    end
end
