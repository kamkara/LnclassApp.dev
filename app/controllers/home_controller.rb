class HomeController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  
  def index
  end

  def team
  end
end
