class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_folders_and_records
end
