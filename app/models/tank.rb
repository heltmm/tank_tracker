class Tank < ActiveRecord::Base
  belongs_to :user

  validates :tank_type, :presence => true
  validates :number, :presence => true

  scope :find_by_number, -> (number, current_user) { where(number: number, user_id: current_user.id)}
end
