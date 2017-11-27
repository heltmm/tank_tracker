class CreateTanks < ActiveRecord::Migration[5.1]
  def change
    create_table :tanks do |t|
      t.column :brewery, :string
      t.column :type, :string
      t.column :number, :number
      t.column :clean, :boolean
      t.column :cleaned_by, :string
      t.column :gyle, :number
      t.column :brand, :string
      t.column :volume, :number
      t.column :sanitized, :boolean
      t.column :sanitized_by, :string
      t.column :dryhopped, :boolean
      t.column :last_acid, :date
      t.column :date_brewed, :date
      t.column :date_filtered, :date
    end
  end
end
