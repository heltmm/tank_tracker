class TanksController < ApplicationController
  def index
    @tanks = Tank.all
    render :index
  end

  def update
    @tanks = Tank.all
    render :index
  end

  def new
    @tank = Tank.new
  end

  def create
    @tank = Tank.new(tank_params)
    if @tank.save
      flash[:notice] = "Tank successfully added!"
      redirect_to tanks_path
    else
      render :new
    end
  end

  private
  def tank_params
    params.require(:tank).permit(:tank_type, :number, :user_id)
  end

end
