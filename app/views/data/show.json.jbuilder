

  if @my_records != nil
    json.date @date
    json.current_temp @my_records.last.temperature.value
    json.current_cond @my_records.last.condition

    json.measurements @my_records do |record|
      json.time record.time.strftime("%l:%M:%S %P")
      json.temp record.temperature.value
      json.precip record.rain.amount
      json.wind_direction record.wind.dir
      json.wind_speed record.wind.speed
    end
  else
    json.problem "Bad location ID"
  end
