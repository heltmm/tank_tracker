class AddRefillCount < ActiveRecord::Migration[5.1]
  def change
    change_table :breweries do |t|
      t.integer :max_refills, default: 3
    end
  end
end
