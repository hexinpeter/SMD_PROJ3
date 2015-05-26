# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'csv'

puts Dir.pwd
locations = CSV.read('./db/Postcodes.csv')


for i in 0..locations.size-1
  postcode = locations[i][0]
  longtitude = locations[i][6]
  latitude = locations[i][5]

  if ( postcode.to_i >= 3000 && postcode.to_i <= 3100 )
    next if PostCode.find_by(num: postcode)
  	pc = PostCode.create(num: postcode)

    loc = Location.new_without_ref_code(
      long: longtitude,
      lat: latitude,
      timezone: "Melbourne"
    )

    loc.post_code = pc
    loc.save!
  end
end