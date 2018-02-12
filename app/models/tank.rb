class Tank < ActiveRecord::Base
  include AASM

  belongs_to :brewery

  delegate :refill_frequency, to: :brewery, prefix: true, allow_nil: true

  validates :tank_type, :presence => true
  validates :number, :presence => true

  aasm column: 'status' do
    state :dirty, :initial => true
    state :clean, :sanitized, :active

    event :clean do
      transitions from: [:dirty, :sanitized], to: :clean
    end

    event :sanitize do
      transitions from: :clean, to: :santized
    end

    event :activate do
      transitions from: :sanitized, to: :active
    end

    event :refill, after_commit: :increment_refill_count do
      transitions from: :active, to: :sanitized, if: :can_be_refilled?
    end

    event :empty, after_commit: :reset_refill_count do
      transitions from: [:active, :sanitized], to: :dirty
    end
  end

  def transfer_to(tank, volume)
    tank.update({:volume => volume, :brand => self.brand, :gyle => self.gyle, :status => self.status, :date_brewed => self.date_brewed })
    self.update({:volume => self.volume - volume})
  end

  def can_remove_volume?(volume_to_transfer)
    volume_to_transfer <= self.volume
  end

  private

  def can_be_refilled?
    binding.pry
    self.refill_count <= self.brewery_refill_frequency
  end

  def increment_refill_count
    binding.pry
    self.refill_count += 1
    self.save
  end

  def reset_refill_count
    self.refill_count = 0
    self.save
  end


end
