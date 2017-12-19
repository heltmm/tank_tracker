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
    @tank = Tank.find_by_number(tank_params[:number], tank_params[:tank_type],current_user).first
    if tank_params[:status] === "Sanitized" and @tank.status != "Clean"
      @message = "Tank must be cleaned before Sanitized!"
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "message" }
      end
    elsif tank_params[:status] === "Dirty"
      @tank.reset_tank
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "tank_update" }
      end
    else
      @tank.update(tank_params)
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "tank_update" }
      end
    end
  end

  def brewer_update
    @tank = Tank.find_by_number(tank_params[:number], tank_params[:tank_type],current_user).first
    if @tank.status === "Sanitized"
      @tank.update(tank_params)
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "tank_update" }
      end
    else
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      flash["alert"] = "Beer can only go into a Sanitzed tank!"
      render :logged_in
    end
  end

  def transfer_update
      @start_tank = Tank.find_by_number(update_params[:from_number], update_params[:from_tank_type], current_user).first
      @finish_tank = Tank.find_by_number(update_params[:to_number], update_params[:to_tank_type], current_user).first
      if @finish_tank.status != "Sanitized"
        @message = "Can't Transfer Beer into an unsanitized tank!"
        @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      elsif update_params[:all] === "true" or update_params[:volume].to_i === @start_tank.volume
        @start_tank.transfer_to(@finish_tank, @start_tank.volume)
        @start_tank.reset_tank
        @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "transfer_update" }
        end
      elsif update_params[:volume].to_i > @start_tank.volume
        @message = "Can not transfer More beer than there is!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      else
        @start_tank.transfer_to(@finish_tank, update_params[:volume].to_i)
        @start_tank.volume -= update_params[:volume].to_i
        @start_tank.save
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "transfer_update" }
        end
      end
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
  end

  def package_update
    @tank = Tank.find_by_number(update_params[:number], update_params[:tank_type], current_user).first
    if update_params[:refill] and @tank.status === "Active"
      @tank.refill_tank
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "tank_update" }
      end
    elsif update_params[:volume].to_i > @tank.volume
      @message = "Can not package more beer than there is!"
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "message" }
      end
    else
      @tank.volume -= update_params[:volume].to_i
      @tank.save
      @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "tank_update" }
      end
    end


  end

  def overide

  end

  def acid_update
    @tank = Tank.find_by_number(update_params[:number], update_params[:tank_type], current_user).first
    @tank.update(update_params)
    @tanks = Tank.where(brewery_id: current_user.brewery.id).sort
    render :logged_in
  end



  private
  def tank_params
    params.require(:tank).permit(:brewery_id, :tank_type, :number, :status, :gyle, :brand, :volume, :dryhopped, :last_acid, :date_brewed, :date_filtered, :initials, :refill_count)
  end

  def update_params
    update_params = params.permit(:number, :brewer_id, :status, :initials, :brand, :gyle, :volume, :last_acid, :bbt_number, :refill, :from_number, :to_number, :all, :tank_type, :from_tank_type, :to_tank_type, :refill_count )
  end


end
