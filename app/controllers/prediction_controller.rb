class PredictionController < ApplicationController
  # GET '/weather/predicition/:lat/:long/:period'
  def show
    @location = Location.find_closest(params['lat'].to_i, params['long'].to_i)
    @predictions = @location ? @location.predictions(params['period'].to_i) : []
    @lat = params['lat'].to_i
    @long = params['long'].to_i
  end

  # GET '/weather/prediction/:post_code/:period'
  def show_area
    @location = Location.find_closest_with_postcode(params['post_code'].to_i)
    @predictions = @location ? @location.predictions(params['period'].to_i) : []
  end
end
