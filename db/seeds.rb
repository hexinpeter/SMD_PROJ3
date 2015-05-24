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
  
  if ( locations[i][0].to_i >= 3000 && locations[i][0].to_i <= 3999 )
    
    Location.create_without_ref_code(
      long: locations[i][6],
      lat: locations[i][5],
      timezone: "Vic"
    )
  end

end