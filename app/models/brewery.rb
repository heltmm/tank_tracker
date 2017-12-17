class Brewery < ActiveRecord::Base
  belongs_to :user
  has_many :tanks

  validates :name, :presence => true

end
