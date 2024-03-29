class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    home_path
  end

  protected
    def layout_by_resource
      if devise_controller? && resource_name == :user && (%w(new create).include?(action_name) || (controller_name == 'passwords' && %w(edit update).include?(action_name) ))
        "unlocking"
      else
        "application"
      end
    end

  private
    def prepare_folders_and_records
      @folders = current_user.folders
      @current_folder = @folders.first
      @folder = Folder.new
      @record = Record.new
    end
end
