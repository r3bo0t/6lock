class RecordsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @folders = current_user.folders
    @folder = Folder.new
    @record = Record.new
    @current_record = Record.get_record_from(@folders, params[:id])
    if @current_record
      @current_record.set_decrypted_password
      @current_folder = @current_record.folder
    else
      flash[:alert] = "You are not allowed to access this resource."
      redirect_to home_path
    end
  end

  def create
    @folder = Folder.where(:id => params[:folder_id], :user_id => current_user.id).first
    if @folder
      @record = @folder.records.build(params[:record])
      @record.save

      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js { render :nothing => true }
      end
    end
  end

  def update
    folder = Folder.where(:id => params[:folder_id], :user_id => current_user.id).first
    if folder
      record = folder.records.find(params[:id])
      record.update_attributes(params[:record])

      redirect_to record_path(record)
    else
      flash[:alert] = "You are not allowed to access this resource."
      redirect_to home_path
    end
  end

  def edit
    @folders = current_user.folders
    @folder = Folder.new
    @record = Record.new
    @current_record = Record.get_record_from(@folders, params[:id])
    if @current_record
      @current_record.set_decrypted_password
      @current_folder = @current_record.folder
    else
      flash[:alert] = "You are not allowed to access this resource."
      redirect_to home_path
    end
  end

  def destroy
    @record = Record.get_record_from(Folder.all, params[:id])
    @record.destroy if @record.folder.user_id == current_user.id

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
end
