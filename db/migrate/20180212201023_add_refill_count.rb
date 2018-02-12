class AddRefillCount < ActiveRecord::Migration[5.1]
  def change
    change_table :breweries do |t|
      t.integer :refill_frequency, default: 3
    end
  end
end
