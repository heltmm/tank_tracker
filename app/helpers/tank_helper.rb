# frozen_string_literal: true
module TankHelper
  def status_to_color(tank)

    case tank.status
    when "sanitized"
      'success'
    when "clean"
      'info'
    when "dirty"
      'danger'
    when "active"
      'warning'
    end
  end
end
