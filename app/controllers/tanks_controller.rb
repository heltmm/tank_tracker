class TanksController < ApplicationController
  def index
    if current_user
      @tanks = Tank.where(brewery_id: current_user.brewery.id)
      @tank = Tank.new
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
    @tank = Tank.find_by_number(cellar_update_params[:number], current_user)
    @tank.update(cellar_update_params)
    @tanks = Tank.where(brewery_id: current_user.brewery.id)
    render :logged_in
  end

  def brewer_update
    params = brewer_update_params
    params[:status] = "Active"
    @tank = Tank.find_by_number(params[:number], current_user).first
    binding.pry
    if @tank.status === "Sanitized"
      @tank.update(params)
      @tanks = Tank.where(brewery_id: current_user.brewery.id)
      render :logged_in
    else

      render :logged_in
    end
  end

  def transfer_update

  end

  def package_update

  end

  def overide

  end



  private
  def tank_params
    params.require(:tank).permit(:tank_type, :number, :brewery_id)
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
    volume: params.require(:volume)}
  end

end
