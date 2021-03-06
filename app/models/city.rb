class City < ActiveRecord::Base
  has_many :stores, :dependent => :destroy
  has_many :deliveries, :through => :stores

  validates_presence_of :name
  validates_uniqueness_of :name

  def pretty_name
    name.titleize
  end
  
  # All Cities in Nebraska
  def self.list
    [
      "Ainsworth",
      "Albion",
      "Alliance",
      "Alma",
      "Arapahoe",
      "Ashland",
      "Atkinson",
      "Auburn",
      "Aurora",
      "Basset",
      "Battle Creek",
      "Bayard",
      "Beatrice",
      "Beaver City",
      "Bellvue",
      "Benkelman",
      "Bennington",
      "Blair",
      "Bloomfield",
      "Blue Hill",
      "Blue Springs",
      "Breslau",
      "Bridgeport",
      "Broken Bow",
      "Burwell",
      "Cambridge",
      "Central City",
      "Chadron",
      "Chappell",
      "Clarks",
      "Clarkson",
      "Clay Center",
      "Columbus",
      "Cozad",
      "Crawford",
      "Creighton",
      "Crete",
      "Crofton",
      "Curtis",
      "Dakota City",
      "David City",
      "Deshler",
      "Edgar",
      "Elgin",
      "Elkhorn",
      "Fairbury",
      "Fairfield",
      "Falls City",
      "Firth",
      "Fort Calhoun",
      "Franklin",
      "Freemont",
      "Friend",
      "Fullerton",
      "Geneva",
      "Genoa",
      "Gering",
      "Gibbon",
      "Gordon",
      "Gothenburg",
      "Grand Island",
      "Grant",
      "Gretna",
      "Hartington",
      "Harvard",
      "Hastings",
      "Hebron",
      "Henderson",
      "Hickman",
      "Holdrege",
      "Hooper",
      "Humbolt",
      "Humphrey",
      "Imperial",
      "Indianola",
      "Kearney",
      "Kimball",
      "Laurel",
      "La Vista",
      "Lexington",
      "Lincoln",
      "Long Pine",
      "Louisville",
      "Loup City",
      "Lyons",
      "Madison",
      "McCook",
      "Milford",
      "Minatare",
      "Minden",
      "Mitchell",
      "Nerbaska City",
      "Neligh",
      "Nelson",
      "Newman Grove",
      "Norfolk",
      "North Bend",
      "North Platte",
      "Oakland",
      "Ogallala",
      "Omaha",
      "O'Neill",
      "Ord",
      "Osceola",
      "Oshkosh",
      "Osmond",
      "Papillion",
      "Pawnee City",
      "Peru",
      "Pierce",
      "Plainview",
      "Plattsmouth",
      "Ponca",
      "Ralston",
      "Randolph",
      "Ravenna",
      "Red Cloud",
      "Rushville",
      "St. Edward",
      "St. Paul",
      "Sargent",
      "Schuyler",
      "Scottsbluff",
      "Scribner",
      "Seward",
      "Sidney",
      "South Sioux City",
      "Springfield",
      "Stanton",
      "Stromsburg",
      "Superior",
      "Sutton",
      "Syracuse",
      "Tecumseh",
      "Tekamah",
      "Tilden",
      "Valentine",
      "Valley",
      "Wahoo",
      "Wakefield",
      "Waterloo",
      "Waverly",
      "Wayne",
      "Weeping Water",
      "West Point",
      "Wilber",
      "Wisner",
      "Wood River",
      "Wymore",
      "York",
      "Yutan"
    ]
  end
end