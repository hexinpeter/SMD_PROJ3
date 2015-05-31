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
      elsif postcode.to_i >= 3000 && postcode <= 3999.to_i
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
