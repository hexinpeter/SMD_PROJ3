json.date @date
json.locations @my_locations do |location|
  json.id location.ref_code
  json.lat location.lat
  json.long location.long
  json.last_update_UNIT_NEED_CLAREFY location.records.last.time

  json.measurements location.records do |record|
    if measurement.time.strftime('%d-%m-%Y') == @date
      json.time record.time
      json.temp record.temperature.value
      json.precip record.rain.amount
      json.wind_direction record.wind.dir
      json.wind_speed record.wind.speed
    end
  end

end
