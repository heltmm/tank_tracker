module ApplicationHelper
  def needs_acid(date, time_passed)

    if date and (date < time_passed.month.ago)
      true
    else
      false
    end
  end
end
