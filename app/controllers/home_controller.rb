class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @often_used = Record.often_used(@folders)
  end
end
