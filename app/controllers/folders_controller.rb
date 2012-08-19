class FoldersController < ApplicationController
  before_filter :authenticate_user!

  def create
    @folder = current_user.folders.build(params[:folder])
    @folder.save
    respond_to do |format|
      format.js
    end
  end

  def update
  end

  def destroy
  end
end
