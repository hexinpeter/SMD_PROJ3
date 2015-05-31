class PredictionController < ApplicationController
  def show

    @post_code = params["post_code"]
    @period = params["period"]
    @my_location_id = Location.find_closest_with_postcode(@post_code).ref_code

    @bad_post_code = false
    if @post_code.to_i < 3000 && @post_code.to_i > PostCode.all.length || @post_code.to_i > 3999 || @my_location_id == nil
      @bad_post_code = true
      return
    end

    @my_predictions = []



  end

  def show_area

    @lat = params["lat"]
    @long = params["long"]
    @period = params["period"]
    @bad_lat_long = false










  end
end
