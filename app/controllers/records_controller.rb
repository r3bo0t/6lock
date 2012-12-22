class RecordsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_folders_and_records

  def show
    @folders = current_user.folders
    @record = Record.new
    @current_record = Record.get_record_from(@folders, params[:id])
    if @current_record
      @current_record.set_decrypted_password(session[:master])
      @current_folder = @current_record.folder
      @current_record.update_attribute('access_count', @current_record.access_count + 1)
    else
      flash[:alert] = "You are not allowed to access this resource."
      redirect_to home_path
    end
  end

  def create
    @folder = Folder.where(:id => params[:folder_id], :user_id => current_user.id).first
    if @folder
      @record = @folder.records.build(params[:record])
      @record.set_password(session[:master])
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
      @record = folder.records.find(params[:id])
      if @record.update_attributes(params[:record])
        if params[:record][:decrypted_password] && !params[:record][:decrypted_password].empty?
          @record.set_password(session[:master])
          @record.save
        end

        if params[:current_record]
          next_folder = Folder.where(:id => params[:current_record][:folder_id], :user_id => current_user.id).first
          if next_folder && next_folder != folder
            new_record = @record.dup
            next_folder.records << new_record
            @record.destroy
            @record = new_record
          end
        end

        respond_to do |format|
          format.html { redirect_to record_path(@record) }
          format.js
        end
      else
        respond_to do |format|
          format.html do
            flash[:record_errors] = @record.errors
            redirect_to edit_record_path(@record)
          end
          format.js
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = "You are not allowed to access this resource."
          redirect_to home_path
        end
        format.js { render :nothing => true }
      end
    end
  end

  def edit
    @folders = current_user.folders
    @record = Record.new
    @current_record = Record.get_record_from(@folders, params[:id])
    if @current_record
      @current_record.set_decrypted_password(session[:master])
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
