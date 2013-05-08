class PasswordsController < Devise::PasswordsController

  # Overriding devise update method to reset all encrypted password and set session[:master]
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)

      records = Record.extract_records_from(resource.folders)
      records.each {|r| r.update_attribute(:password, '') }
      session[:master] = resource_params[:password]

      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      respond_with resource
    end
  end

end