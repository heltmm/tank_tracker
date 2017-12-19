class Tank < ActiveRecord::Base
  belongs_to :brewery

  validates :tank_type, :presence => true
  validates :number, :presence => true

  scope :find_by_number, -> (number, type, current_user) { where(number: number, brewery_id: current_user.brewery.id, tank_type: type)}

  def reset_tank
    self.update(:gyle => nil, :brand=> nil, :volume => nil, :dryhopped => nil, :last_acid => nil, :date_brewed => nil, :date_filtered => nil, :initials => nil, :status => "Dirty")
  end

  def transfer_to(tank, volume)
    tank.update({:volume => volume, :brand => self.brand, :gyle => self.gyle, :status => self.status, :date_brewed => self.date_brewed })
  end
end
