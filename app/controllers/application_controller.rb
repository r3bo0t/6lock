class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    home_path
  end

  private
    def prepare_folders_and_records
      @folders = current_user.folders
      @current_folder = @folders.first
      @folder = Folder.new
      @record = Record.new
    end
end
