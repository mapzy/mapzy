# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


users = User.create([
  {name: "Jon Snow", email: "aegon@mapzy.io", password: "iloveghost12",  password_confirmation: "iloveghost12"},
  {name: "Daenerys Targaryen", email: "danny@mapzy.io", password: "breakerofchains10", password_confirmation: "breakerofchains10"}
])

maps = Map.create([
  {name: "Global", user: users.first},
  {name: "Berlin", user: users.second}
])


Locations.create([
  {
    map: maps.first,
    city: "New York",
    zip_code: "12345",
    country_code: "US",
    description: "This is a fun little store!"
  }
])