class Tank < ActiveRecord::Base
  belongs_to :user

  validates :type, :presence => true
end
