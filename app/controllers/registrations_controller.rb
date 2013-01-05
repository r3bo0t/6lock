class RegistrationsController < Devise::RegistrationsController
  before_filter :prepare_folders_and_records, :only => [:edit, :update]

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_with_password(resource_params)
      if is_navigational_format?
        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
          flash_key = :update_needs_confirmation
        end
        set_flash_message :notice, flash_key || :updated
      end
      sign_in resource_name, resource, :bypass => true
      if params[:user] && params[:user][:password]
        records = Record.extract_records_from(current_user.folders)
        records.each do |record|
          record.set_decrypted_password(session[:master])
          record.set_password(params[:user][:password])
          record.save
        end
        session[:master] = params[:user][:password]
      end
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

    def after_update_path_for(resource)
      home_path
    end
end