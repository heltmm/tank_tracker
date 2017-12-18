class TanksController < ApplicationController
  def index
    if current_user
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      @tank = Tank.new
      render :logged_in
    else
      render :index
    end
  end

  def new
    @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
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
    @tank = Tank.find_by_number(tank_params[:number], current_user).first
    if tank_params[:status] === "Sanitized" and @tank.status != "Clean"
      flash["alert"] = "Tank must be cleaned before Sanitized!"
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      render :logged_in
    else
      @tank.update(tank_params)
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      render :logged_in
    end
  end

  def brewer_update
    @tank = Tank.find_by_number(tank_params[:number], current_user).first
    if @tank.status === "Sanitized"
      @tank.update(tank_params)
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      render :logged_in
    else
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      flash["alert"] = "Beer can only go into a Sanitzed tank!"
      render :logged_in
    end
  end

  def transfer_update

  end

  def package_update

  end

  def overide

  end

  def acid_update

    @tank = Tank.find_by_number(params[:number], current_user).first
    @tank.update(acid_update_params)
    @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
    render :logged_in
  end



  private
  def tank_params
    params.require(:tank).permit(:brewery_id, :tank_type, :number, :status, :gyle, :brand, :volume, :dryhopped, :last_acid, :date_brewed, :date_filtered, :initials)
  end

  def update_params
    {number: params.permit(:number),
    status: params.permit(:status),
    initials: params.permit(:initials),
    brand: params.permit(:brand),
    gyle: params.permit(:gyle),
    volume: params.permit(:volume),
    last_acid: params.permit(:last_acid),
    bbt_number: params.permit(:bbt_number),
    refill: params.permit(:refill),
    from_number: params.permit(:from_number),
    to_number: params.permit(:to_number),
    all: params.permit(:all)}
  end

end
