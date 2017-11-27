class TanksController < ApplicationController
  def index
    if current_user
      @tanks = Tank.where(user_id: current_user.id)
      render :logged_in
    else
      render :index
    end
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

  def cellar_update
    binding.pry
    @tanks = Tank.where(user_id: current_user.id)
    render :logged_in
  end

  def brewer_update
    binding.pry
    @tanks = Tank.where(user_id: current_user.id)
    render :logged_in
  end

  private
  def tank_params
    params.require(:tank).permit(:tank_type, :number, :user_id)
  end

  def cellar_update_params
    {number: params.require(:number),
    status: params.require(:status),
    initials: params.require(:initials)}
  end

  def brewer_update_params
    {number: params.require(:number),
    gyle: params.require(:gyle),
    brand: params.require(:brand),
    volue: params.require(:volume)}
  end

end
