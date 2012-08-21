class RecordsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @folders = current_user.folders
    @folder = Folder.new
    @record = Record.get_record_from(@folders, params[:id])
    flash.now[:alert] = "You are not allowed to access this resource." unless @record
  end

  def create
#    @record = current_user.folders.build(params[:folder])
#    @folder.save

#    respond_to do |format|
#      format.js
#    end
  end

  def update
  end

  def edit
  end

  def destroy
#    @folder = Folder.find(params[:id])
#    @folder.destroy if @folder.user_id == current_user.id

#    respond_to do |format|
#      format.js { render :nothing => true }
#    end
#  end
end
