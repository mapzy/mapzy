# Map 1: Global

user = User.create!(email: "aegon@mapzy.io", password: "iloveghost12",  password_confirmation: "iloveghost12")
user.create_account

map = user.maps.create!(name: "Global")

addresses = ["87313 Pfeffer Roads, Apt. 963, 69658, North Ernestina, Georgia, United States","3871 Shaina Villages, Suite 487, 00911, Luisastad, Vermont, United States","11654 Harvey Mountain, Apt. 244, 04147, Schambergerville, Minnesota, United States","5683 DuBuque Shoal, Suite 674, 05722, Schultzstad, Wyoming, United States","84028 Braeden Way, Suite 724, 97418-4209, East Derick, Virginia, United States","Volhardstr. 43, 9 OG, 12114, Neu Jarischeid, Nordrhein-Westfalen, Germany","Ludwig-Knorr-Str. 92b, Zimmer 584, 52811, Inesland, Sachsen-Anhalt, Germany","Juliesgate 17, Leil. 049, 9788, Vestø,  Norway","Østre Bekketjernet 57, Leil. 641, 0468, Sandstrand,  Norway","Namık Kemal Caddesi 2, Suite 078, 80922, Bingöl, Kütahya, Turkey","Gül Sokak 05, Suite 710, 39788, Çanakkale, Adiyaman, Turkey"]
addresses.each_with_index do |addr, i|
  map.locations.create!(name: "Global Store #{i}", description: "This is a fun lil store!", address: addr)
end

# Map 2: US

user = User.create!(email: "danny@mapzy.io", password: "breakerofchains10", password_confirmation: "breakerofchains10")
user.create_account

map = user.maps.create!(name: "US")

addresses = ["56063 Zulauf Overpass, Suite 063, 18756-8365, Collinschester, New Hampshire, United States","26252 Jalen Causeway, Suite 011, 37395, Lake Cedrick, South Dakota, United States","48249 Bruen Court, Apt. 655, 98256, Marquesberg, Connecticut, United States","009 Thompson Flats, Suite 690, 48086, North Nealberg, South Dakota, United States","2700 O'Kon Rest, Suite 060, 29178, Denesikfort, Rhode Island, United States","4380 Abbott Ways, Suite 274, 24980, South Cruztown, Minnesota, United States","676 Felicia Trail, Suite 904, 05615-0144, Janview, Kansas, United States","2565 Jany Parks, Apt. 413, 17319, Lake Katelinmouth, North Carolina, United States","5993 Torphy Extensions, Apt. 044, 11392-6466, Lake Felicity, Minnesota, United States","8585 Baby Burg, Suite 375, 04128, Raulton, New Hampshire, United States"]
addresses.each_with_index do |addr, i|
  map.locations.create!(name: "US Store #{i}", description: "This is a fun lil store!", address: addr)
end

# Map 3: Zürich

user = User.create!(email: "tyrion@mapzy.io", password: "smartass007", password_confirmation: "smartass007")
user.create_account

map = user.maps.create!(name: "Zürich")

addresses = ["Hohlstrasse 117, 8004, Zürich, Switzerland, ","Langstrasse 102, 8004, Zürich, Switzerland", "Stüssihofstatt 14, 8001 Zürich, Switzerland"]
addresses.each_with_index do |addr, i|
  map.locations.create!(name: "Zürich Store #{i}", description: "This is a fun lil store!", address: addr)
end
