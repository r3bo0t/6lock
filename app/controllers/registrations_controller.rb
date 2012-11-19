class RegistrationsController < Devise::RegistrationsController
  before_filter :prepare_folders_and_records, :only => [:edit]
end