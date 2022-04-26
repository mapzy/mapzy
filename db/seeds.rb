days = %w[monday tuesday wednesday thursday friday saturday sunday]

# Map 1: Global

user = User.create!(email: "aegon@mapzy.io", password: "iloveghost12",  password_confirmation: "iloveghost12")
user.create_account

map = user.maps.create!(name: "Global")

addresses = [
  "689 Townsend, San Francisco, CA 94103, United States",
  "25 avenue des Champs Elysées, Paris, France",
  "Hohlstrasse 117, 8004, Zürich, Switzerland",
  "Av. Vinte de Janeiro, S/N - Terminal 2 - Galeão, Rio de Janeiro - RJ, 21941-570, Brazil",
  "Pali, Faridabad, Faridabad, Haryana, India",
  "Sarabha Nagar Ground Floor, 5 F Ludhiana, PB 141001, India",
  "Kübra Tekin Moda Tasarim, Atasehir, Atasehir, Istanbul 34758, Turkey",
  "Kölpinseeweg 74, 13599 Berlin, Germany"
]
addresses.each_with_index do |addr, i|
  location = map.locations.create!(name: "Global Store #{i}", description: "This is a fun lil store!", address: addr)
  days.each do |d|
    location.opening_times.create!(day: d, opens_at: "08:00", closes_at: "18:00")
  end
end

# Map 2: US

user = User.create!(email: "danny@mapzy.io", password: "breakerofchains10", password_confirmation: "breakerofchains10")
user.create_account

map = user.maps.create!(name: "US")

addresses = [
  "351 Merrick Rd, Amityville, NY 11701, United States",
  "2430 Market Street NE1001, Washington, DC 20018, United States",
  "1320 Londontown Blvd, Eldersburg, MD 21784, United States",
  "2350 Troy Rd, Edwardsville, IL 62025, United States",
  "10755 N Freeway, Houston, TX 77037, United States",
  "1356 Third Street Promenade, Santa Monica, CA 90401, United States",
  "689 Townsend, San Francisco, CA 94103, United States",
  "340 228 Ave. NE, Sammamish, WA 98074, United States"
]
addresses.each_with_index do |addr, i|
  map.locations.create!(name: "US Store #{i}", description: "This is a fun lil store!", address: addr)
end

# Map 3: Zürich

user = User.create!(email: "tyrion@mapzy.io", password: "smartass007", password_confirmation: "smartass007")
user.create_account

map = user.maps.create!(name: "Zürich")

addresses = [
  "Hohlstrasse 117, 8004, Zürich, Switzerland",
  "Langstrasse 102, 8004, Zürich, Switzerland",
  "Stüssihofstatt 14, 8001 Zürich, Switzerland"
]
addresses.each_with_index do |addr, i|
  map.locations.create!(name: "Zürich Store #{i}", description: "This is a fun lil store!", address: addr)
end

# Map 4: Paris
# Locations are pending or erroneous

user = User.create!(email: "jorah@mapzy.io", password: "ilovedanny", password_confirmation: "ilovedanny")
user.create_account

map = user.maps.create!(name: "Paris")

pending_addresses = ["Place de la République, Paris, France", "10 avenue de la Bastille, Paris, France"]
success_addresses = ["25 avenue des Champs Elysées, Paris, France", "3 rue Mouffetard, Paris, France"]
error_addresses = %w[popopopopo pipipipipi pupupupupu papapapapa]

pending_addresses.each_with_index do |addr, i|
  map.locations.create(name: "Paris Store #{i}", description: "This is a fun lil store!", address: addr, skip_geocoding: true)
end

success_addresses.each_with_index do |addr, i|
  map.locations.create(name: "Paris Store #{i}", description: "This is a fun lil store!", address: addr)
end

error_addresses.each_with_index do |addr, i|
  map.locations.create(name: "Weird Store #{i}", description: "This is weird.", address: addr)
end