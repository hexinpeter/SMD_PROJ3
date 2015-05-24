module UnitConversion
  extend ActiveSupport::Concern

  def fahrenheit_to_celsius(value)
    (value - 32) * 5 / 9
  end

  def miles_to_km(value)
    value * 1.609344
  end

  def bearing_to_dir(value)
    seg = 360/32.to_f
    directions = ['N', 'NNE', 'NNE', 'NE','NE', 'ENE', 'ENE', 'E', 'E', 'ESE', 'ESE', 'SE', 'SE', 'SSE', 'SSE', 'S', 'S', 'SSW', 'SSW', 'SW', 'SW', 'WSW', 'WSW', 'W', 'w', 'WNW', 'WNW', 'NW', 'NW', 'NNW', 'NNW', 'N']
    return directions[(value/seg).to_i]
  end

  def inch_to_mm(value)
    value * 25.4
  end
end