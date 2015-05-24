json.date @date.strftime('%d-%m-%Y')
json.locations @locations do |location|
  json.id location.ref_code
  json.(location, :long, :lat)
  json.late_update location.last_update
end

