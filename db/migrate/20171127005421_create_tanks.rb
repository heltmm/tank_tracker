class CreateTanks < ActiveRecord::Migration[5.1]
  def change
    create_table :tanks do |t|
      t.column :user_id, :integer
      t.column :tank_type, :string
      t.column :number, :integer
      t.column :clean, :boolean
      t.column :cleaned_by, :string
      t.column :gyle, :integer
      t.column :brand, :string
      t.column :volume, :integer
      t.column :sanitized, :boolean
      t.column :sanitized_by, :string
      t.column :dryhopped, :boolean
      t.column :last_acid, :date
      t.column :date_brewed, :date
      t.column :date_filtered, :date
    end
  end
end
