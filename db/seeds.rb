users = User.create!([
  {name: "Jon Snow", email: "aegon@mapzy.io", password: "iloveghost12",  password_confirmation: "iloveghost12"},
  {name: "Daenerys Targaryen", email: "danny@mapzy.io", password: "breakerofchains10", password_confirmation: "breakerofchains10"}
])

maps = Map.create!([
  {name: "Global", user: users.first},
  {name: "Berlin", user: users.second}
])


Location.create!([
  {
    map: maps.first,
    name: "Location 1",
    address_line1: "7018 Pilgrim Lane",
    city: "Hesperia",
    zip_code: "92345",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 2",
    address_line1: "7213 W. Swanson Ave.",
    city: "Lynwood",
    zip_code: "90262",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 3",
    address_line1: "615 S. Carriage St.",
    city: "Corona",
    zip_code: "92882",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 4",
    address_line1: "21 Thatcher Lane",
    city: "El Cajon",
    zip_code: "92020",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 5",
    address_line1: "7316 Marshall Court",
    city: "New York",
    zip_code: "10002",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 6",
    address_line1: "7316 Marshall Court",
    city: "New York",
    zip_code: "10002",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 7",
    address_line1: "42 West Lane",
    city: "Buffalo",
    zip_code: "14215",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 8",
    address_line1: "7216 Cottage Street",
    city: "Brooklyn",
    zip_code: "11208",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 9",
    address_line1: "30 Atlantic Road",
    city: "Brooklyn",
    zip_code: "11211",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 10",
    address_line1: "49 Gartner Street",
    city: "Bronx",
    zip_code: "10457",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 11",
    address_line1: "163 Sage Ave.",
    city: "Bay Shore",
    zip_code: "11706",
    country_code: "US",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 12",
    address_line1: "9520 The Avenue",
    city: "Harrow",
    zip_code: "HA65 4AJ",
    country_code: "GB",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 13",
    address_line1: "76 Church Road",
    city: "Canterbury",
    zip_code: "CT8 7CI",
    country_code: "GB",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 14",
    address_line1: "452 Mill Lane",
    city: "Bath",
    zip_code: "BA16 5TJ",
    country_code: "GB",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 15",
    address_line1: "82 High Street",
    city: "Edinburgh",
    zip_code: "EH95 0CH",
    country_code: "GB",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 16",
    address_line1: "444 Grange Road",
    city: "Shrewsbury",
    zip_code: "SY47 8MF",
    country_code: "GB",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 17",
    address_line1: "73 Main Street",
    city: "St Albans",
    zip_code: "AL30 2UK",
    country_code: "GB",
    description: "This is a fun little store!"
  },
  {
    map: maps.first,
    name: "Location 18",
    address_line1: "426 North Road",
    city: "London",
    zip_code: "W93 6KU",
    country_code: "GB",
    description: "This is a fun little store!"
  },
])