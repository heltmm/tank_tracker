class Tank < ActiveRecord::Base
  belongs_to :brewery

  validates :tank_type, :presence => true
  validates :number, :presence => true

  scope :find_by_number, -> (number, current_user) { where(number: number, brewery_id: current_user.brewery.id)}

  def reset_tank
    binding.pry
    self.update(:gyle => nil, :brand=> nil, :volume => nil, :dryhopped => nil, :last_acid => nil, :date_brewed => nil, :date_filtered => nil, :initials => nil, :status => "Dirty")
  end
end
