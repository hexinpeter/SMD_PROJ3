require 'csv'

class Location < ActiveRecord::Base
  belongs_to :post_code
  has_many :records

  delegate :predicted_records, :actual_records, to: :records


  def last_update
    latest = actual_records.order(:time).last
    latest ? latest.time.strftime('%H:%M%p %d-%m-%Y').downcase : 'N/A'
  end

  def cal_distance(long, lat)
    (self.lat - lat).abs + (self.long - long).abs
  end

  # Generate the predicitons for the next 180 minutes, once for every 10 minutes, and store that in db
  # Actual records of the past 180 minutes has to be present for predictions to be done.
  # Return nil if there is not enough data for predictions.
  # Return 1 when action is complete.
  def generate_predictions
    # the last prediction is made less than 10 min ago
    return 1 if predicted_records.any? && (Time.now - predicted_records.last.created_at) < 600

    past_records = actual_records.where(time: (Time.now - 180.minutes)..Time.now)

    return nil if past_records.length < 0

    ref_time = past_records.order(:time).last.time

    time_data = past_records.map { |rec| rec.time.to_i }
    temp_value_data = past_records.map { |rec| rec.temperature.value }
    temp_dew_data = past_records.map { |rec| rec.temperature.dew_point }
    wind_speed_data = past_records.map { |rec| rec.wind.speed }
    rain_data = past_records.map { |rec| rec.rain.amount }

    temp_value_analyser = DataAnalysis.new(time_data, temp_value_data)
    p temp_value_analyser
    temp_dew_analyser = DataAnalysis.new(time_data, temp_dew_data)
    p temp_dew_analyser
    wind_speed_analyser = DataAnalysis.new(time_data, wind_speed_data)
    p wind_speed_analyser
    rain_analyser = DataAnalysis.new(time_data, rain_data)
    p rain_analyser

    (1..18).each do |i|
      pred_time = ref_time + i * 10.minutes
      pred_rec = predicted_records.create(time: pred_time, created_at: pred_time)
      pred_rec.temperature = Temperature.create(value: temp_value_analyser.extrapolate(pred_time.to_i)[0],
                                  dew_point: temp_dew_analyser.extrapolate(pred_time.to_i)[0],
                                  prob: temp_value_analyser.extrapolate(pred_time.to_i)[1])
      pred_rec.wind = Wind.create(dir: past_records.last.wind.dir,
                           speed: wind_speed_analyser.extrapolate(pred_time.to_i)[0],
                           prob: wind_speed_analyser.extrapolate(pred_time.to_i)[1])
      pred_rec.rain = Rain.create(amount: rain_analyser.extrapolate(pred_time.to_i)[0],
                           prob: rain_analyser.extrapolate(pred_time.to_i)[1])
    end

    return 1
  end


  class << self
    # Find the closest location in the database
    # Return nil if the sum of differences between the provided long lat values and those of the closest
    #   location exceeds 1 (appr. 100km)
    def find_closest(long, lat)
      result = Location.first
      smallest = result.cal_distance(long, lat)

      Location.all.each do |loc|
        if loc.cal_distance(long, lat) < smallest
          smallest = loc.cal_distance(long, lat)
          result = loc
        end
      end

      smallest <= 1 ? result : nil
    end


    def find_closest_with_postcode(postcode)
      if PostCode.where(num: postcode).any?
        return PostCode.where(num: postcode).first.locations.first
      elsif postcode >= 3000 && postcode <= 3999
        # reading from the csv to get lat and long
        locations = CSV.read(Rails.root.join('db', 'Postcodes.csv'))
        locations.each do |loc|
          pc = loc[0].to_i
          long = loc[6].to_d
          lat = loc[5].to_d
          if pc == postcode
            return find_closest(long, lat)
          end
        end
      end
      nil
    end


    def create_without_ref_code(params={})
      loc = Location.new(params)
      loc.ref_code = generate_ref_code
      loc.save!
      loc
    end


    def new_without_ref_code(params={})
      loc = Location.new(params)
      loc.ref_code = generate_ref_code
      loc
    end

  end

  private
    def Location.generate_ref_code
      max_ref_code = Location.any? ? Location.order(:ref_code).last.ref_code : nil
      max_ref_code ? max_ref_code + 1 : 10000
    end

end
