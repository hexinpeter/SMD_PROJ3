require "#{Rails.root}/app/support/unit_conversion.rb"

namespace :weather do
  include UnitConversion

  desc "Get current weather data from Forecast.io"
  task forecastio: :environment do
    Location.all.each do |station|
      next if !station.long or !station.lat

      result = JSON.parse RestClient.get("https://api.forecast.io/forecast/581e88295e8299482824f5449884df1b/#{station.lat.to_s},#{station.long.to_s}")

      # Time data
      record = Record.new_with_unix_time result['currently']['time']
      record.location = station

      # Temperature data
      current_temperature = fahrenheit_to_celsius(result['currently']['temperature'].to_f)
      dew_temperature = fahrenheit_to_celsius(result['currently']['dewPoint'].to_f)
      record.temperature = Temperature.create(value: current_temperature, dew_point: dew_temperature, prob: 1)

      # Wind data
      wind_speed = miles_to_km result['currently']['windSpeed'].to_f
      wind_dir = bearing_to_dir result['currently']['windBearing'].to_f
      record.wind = Wind.create(dir: wind_dir, speed: wind_speed, prob: 1)

      # Precipitation data
      rain_amount = inch_to_mm result['currently']['precipIntensity'].to_f
      record.rain = Rain.create(amount: rain_amount, prob: 1)

      record.save!

      p "Station ##{station.ref_code} data has been retrieved from Forecast.io"
    end
  end

end
