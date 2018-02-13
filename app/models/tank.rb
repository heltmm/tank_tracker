class Tank < ActiveRecord::Base
  include AASM

  belongs_to :brewery

  delegate :max_refills, to: :brewery, prefix: true, allow_nil: true

  validates :tank_type, :presence => true
  validates :number, :presence => true
  validates :number, uniqueness: { scope: :tank_type }

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

    event :empty, after_commit: :reset_tank do
      transitions from: [:active, :clean, :sanitized], to: :dirty
    end
  end

  def transfer_to(tank, volume)
    tank.update({:volume => volume, :brand => self.brand, :gyle => self.gyle, :status => self.status, :date_brewed => self.date_brewed })
    self.update({:volume => self.volume - volume})
  end

  def can_remove_volume?(volume_to_transfer)
    volume_to_transfer <= self.volume
  end

  def start_brew
    self.status = :active
    self.date_brewed = Time.now
  end

  private

  def can_be_refilled?
    self.refill_count < self.brewery_max_refills
  end

  def increment_refill_count
    self.brand = nil
    self.volume = nil
    self.gyle = nil
    self.date_brewed = nil
    self.refill_count += 1
    self.initials = "Refill #{self.refill_count}"
    self.save
  end

  def reset_tank
    self.refill_count = 0
    self.brand = nil
    self.volume = nil
    self.gyle = nil
    self.date_brewed = nil
    self.save
  end


end
