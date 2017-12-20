class TanksController < ApplicationController
  def index
    if current_user
      @tanks = current_user.brewery.tanks.sort
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
    if @tank = Tank.find_by_number(tank_params[:number], tank_params[:tank_type],current_user).first
      if tank_params[:status] === "Sanitized" and @tank.status != "Clean"
        @message = "Tank must be cleaned before Sanitized!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      elsif tank_params[:status] === "Dirty"
        @tank.reset_tank
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "cellar_update" }
        end
      else
        @tank.update(tank_params)
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "cellar_update" }
        end
      end
    else
      @message = "Can not Find Tank"
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "message" }
      end
    end
  end

  def brewer_update
    if @tank = Tank.find_by_number(tank_params[:number], tank_params[:tank_type],current_user).first
      if @tank.status === "Sanitized"
        @tank.update(tank_params)
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "brew_update" }
        end
      else
        @message = "Beer can only go into a Sanitzed tank!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "brew_update" }
        end
      end
    else
      @message = "Can not Find Tank"
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "message" }
      end
    end
  end

  def transfer_update
    if @start_tank = Tank.find_by_number(update_params[:from_number], update_params[:from_tank_type], current_user).first or @finish_tank = Tank.find_by_number(update_params[:to_number], update_params[:to_tank_type], current_user).first
      if @finish_tank.status != "Sanitized"
        @message = "Can't Transfer Beer into an unsanitized tank!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      elsif update_params[:all] === "true" or update_params[:volume].to_i === @start_tank.volume
        @start_tank.transfer_to(@finish_tank, @start_tank.volume)
        @start_tank.reset_tank
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
    else
      @message = "Can not Find Tank"
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "message" }
      end
    end
  end

  def package_update
    if @tank = Tank.find_by_number(update_params[:number], update_params[:tank_type], current_user).first
      if update_params[:refill] and @tank.status === "Active"
        @tank.refill_tank
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "package_update" }
        end
      elsif update_params[:volume].to_i > @tank.volume
        @message = "Can not package more beer than there is!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      else
        @tank.volume -= update_params[:volume].to_i
        @tank.save
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "package_update" }
        end
      end
    else
      @message = "Can not Find Tank"
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "message" }
      end
    end
  end

  def overide
    if @tank = Tank.find_by_number(tank_params[:number], tank_params[:tank_type],current_user).first
      if @tank.status === "Active"
        @tank.update(tank_params)
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "overide" }
        end
      else
        @message = "Can Only Overide an Active tank!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      end
    else
      @message = "Can not Find Tank"
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "message" }
      end
    end
  end

  def acid_update
    @tank = Tank.find_by_number(update_params[:number], update_params[:tank_type], current_user).first
    @tank.update(update_params)
    respond_to do |format|
      format.html {redirect_to tanks_path}
      format.js { render "layouts/acid_update" }
    end
  end



  private
  def tank_params
    params.require(:tank).permit(:brewery_id, :tank_type, :number, :status, :gyle, :brand, :volume, :dryhopped, :last_acid, :date_brewed, :date_filtered, :initials, :refill_count)
  end

  def update_params
    update_params = params.permit(:number, :brewer_id, :status, :initials, :brand, :gyle, :volume, :last_acid, :bbt_number, :refill, :from_number, :to_number, :all, :tank_type, :from_tank_type, :to_tank_type, :refill_count )
  end


end
