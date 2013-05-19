class FoldersController < ApplicationController
  before_filter :authenticate_user!

  def create
    @folder = current_user.folders.build(params[:folder])
    @folder.save
    @record = Record.new

    respond_to do |format|
      format.js
    end
  end

  def update
    @folder = Folder.where(:id => params[:id], :user_id => current_user.id).first
    if @folder
      @folder.update_attributes(params[:folder])

      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js { render :nothing => true }
      end
    end
  end

  def destroy
    @folder = Folder.find(params[:id])
    @folder.destroy if @folder.user_id == current_user.id

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
end
