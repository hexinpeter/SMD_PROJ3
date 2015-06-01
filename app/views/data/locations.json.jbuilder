json.date @date.strftime('%d-%m-%Y')
json.locations @locations do |location|
  json.id location.ref_code
  json.(location, :long, :lat)
  json.last_update location.records.last.time
end
