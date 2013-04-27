class RecordsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_folders_and_records

  def show
    @current_record = Record.get_record_from(@folders, params[:id])
    if @current_record
      @current_record.set_decrypted_password(session[:master])
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
            @record = @record.move_to_folder(next_folder, session[:master])
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
    @record = Record.get_record_from(@folders, params[:id])
    @record.destroy if @record.folder.user_id == current_user.id

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

  def export
    records = Record.extract_records_from(@folders).sort_by(&:name)
    records.each {|r| r.set_decrypted_password(session[:master]) }
    respond_to do |format|
      format.csv { send_data Record.to_csv(records), :filename => '6lock_records.csv' }
    end
  end

  def delete_favorite
    record = Record.get_record_from(@folders, params[:id])
    if record
      record.update_attribute(:position, nil)
    else
      flash[:alert] = "You are not allowed to access this resource."
    end
    redirect_to home_path
  end

  def set_favorite
    record_id = params[:favorite].first.last
    position = params[:favorite].first.first
    records = Record.extract_records_from(@folders)
    record = records.select {|r| r.id.to_s == record_id }.first
    if record
      old = records.select {|r| r.position == position.to_i }.first
      if old then old.update_attribute(:position, nil) end
      record.update_attribute(:position, position)
    else
      flash[:alert] = "You are not allowed to access this resource."
    end
    redirect_to home_path
  end
end
