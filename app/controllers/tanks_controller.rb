class TanksController < ApplicationController
  def index
    @tanks = Tank.all
    render :index
  end
  def update
    binding.pry
    @tanks = Tank.all
    render :index
  end
end
