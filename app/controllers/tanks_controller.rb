class TanksController < ApplicationController


  before_action :fetch_tank, only: [:brewer_update, :package_update, :cellar_update, :acid_update]

  def index
    if current_user
      @tanks = current_user.brewery.tanks.order(tank_type: :desc, number: :asc)
      @tank = Tank.new
      render :logged_in
    else
      render :index
    end
  end

  def table
    if current_user
      @tanks = current_user.brewery.tanks.sort
      @tank = Tank.new
      render :table
    else
      render :index
    end
  end

  def new
    @tank = Tank.new
    @tanks = current_user.brewery.tanks.sort
    @tanks_select = @tanks.map{|tank| [tank.tank_type + tank.number.to_s, tank.id ]}
  end

  def destroy
    @tanks = current_user.brewery.tanks.sort
    @tanks_select = @tanks.map{|tank| [tank.tank_type + tank.number.to_s, tank.id ]}
    @tank = Tank.find(tank_params[:id])
    if @tank.destroy
      flash[:alert] = "Tank successfully removed!"
    end
    render :new
  end

  def create
    @tanks = current_user.brewery.tanks.sort
    @tanks_select = @tanks.map{|tank| [tank.tank_type + tank.number.to_s, tank.id ]}
    @tank = Tank.new(tank_params)
    if @tank.save
      flash[:notice] = "Tank successfully added!"
    end
    render :new
  end

  def cellar_update
    if @tank
      if tank_params[:status] == "sanitized" && !@tank.clean?
        @message = "Tank must be cleaned before Sanitized!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      elsif tank_params[:status] == "dirty"
        @tank.empty
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
    end
  end

  def brewer_update
    if @tank
      if @tank.sanitized?
        @tank.update(tank_params)
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "brew_update" }
        end
      else
        @message = "Beer can only go into a Sanitzed tank!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      end
    end
  end

  def transfer_update
    @start_tank = fetch_tank(:from_number, :from_tank_type)
    @finish_tank = fetch_tank(:to_number, :to_tank_type)

    if @start_tank && @finish_tank
      if !@finish_tank.sanitized?
        @message = "Can not Transfer Beer into an unsanitized tank!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      elsif tank_params[:all] == "true" || tank_params[:volume].to_i == @start_tank.volume
        @start_tank.transfer_to(@finish_tank, @start_tank.volume)
        @start_tank.empty!
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "transfer_update" }
        end
      elsif !@start_tank.can_remove_volume?(tank_params[:volume].to_i)
        @message = "Can not transfer More beer than there is!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      else
        @start_tank.transfer_to(@finish_tank, tank_params[:volume].to_i)
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "transfer_update" }
        end
      end
    end
  end

  def package_update
    if @tank
      if tank_params[:refill] and @tank.active?
        @tank.refill!
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "package_update" }
        end
      elsif !@tank.can_remove_volume?(tank_params[:volume].to_i)
        @message = "Can not package more beer than there is!"
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "message" }
        end
      else
        @tank.volume -= tank_params[:volume].to_i
        @tank.save
        respond_to do |format|
          format.html {redirect_to tanks_path}
          format.js { render "package_update" }
        end
      end
    end
  end

  def overide
    if @tank
      if @tank.active?
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
    end
  end

  def acid_update
    if @tank
      @tank.update(tank_params)
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "layouts/acid_update" }
      end
    end
  end

  private
  def tank_params

    params.require(:tank).permit(:brewery_id, :tank_type, :number, :status, :gyle, :brand, :volume, :dryhopped, :last_acid, :date_brewed, :date_filtered, :initials, :refill_count, :id, :from_number, :to_number, :from_tank_type, :to_tank_type, :tank_type, :all, :refill)

  end

  def fetch_tank(tank_param_name = :number, tank_type_param_name = :tank_type)
    @tank = Tank.find_by_number_and_tank_type(tank_params[tank_param_name], tank_params[tank_type_param_name])
    if @tank.nil?
      @message = "Can not Find Tank"
      respond_to do |format|
        format.html {redirect_to tanks_path}
        format.js { render "message" }
      end
    end

    @tank
  end


end
