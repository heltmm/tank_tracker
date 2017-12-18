# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create!(email: "test@gmail.com", password: "password")
Brewery.create!(name: "Good Brewing Company", user_id: User.last.id)

count = 1
8.times do
  Tank.create!(tank_type: "FV", brewery_id: Brewery.last.id, number: count)
  count += 1
end

3.times do
  Tank.create!(tank_type: "BBT", brewery_id: Brewery.last.id, number: count)
  count += 1
end
