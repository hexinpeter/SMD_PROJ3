json.date @date

json.locations @my_locations do |location|
  json.id location.ref_code
  json.lat location.lat
  json.long location.long
  json.last_update location.records.last.time.strftime("%H:%M%P %d-%m-%Y")

  json.measurements location.records do |record|
    if record.time.strftime('%d-%m-%Y') == @date
      json.time record.time.strftime("%l:%M:%S %P")
      json.temp record.temperature.value
      json.precip record.rain.amount
      json.wind_direction record.wind.dir
      json.wind_speed record.wind.speed
    end
  end

end
