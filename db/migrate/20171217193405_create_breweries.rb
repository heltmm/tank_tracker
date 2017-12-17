class CreateBreweries < ActiveRecord::Migration[5.1]
  def change
    create_table :breweries do |t|
      t.column :user_id, :integer
      t.column :name, :string
    end
  end
end
