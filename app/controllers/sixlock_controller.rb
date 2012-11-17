class SixlockController < ApplicationController
  skip_before_filter :prepare_folders_and_records

  def home
    # Redirection temporaire
    redirect_to home_path
  end
end
