class PasswordsController < Devise::PasswordsController

  # Overriding devise create method to always act as if the recovering instructions were sent
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)


    flash[:notice] = "You will receive an email with instructions about how to reset your password in a few minutes." unless successfully_sent?(resource)
    respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
  end

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