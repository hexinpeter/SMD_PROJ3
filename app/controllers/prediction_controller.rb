class PredictionController < ApplicationController
  def show
  end

  # GET '/weather/prediction/:post_code/:period'
  def show_area
    @location = Location.find_closest_with_postcode(params['post_code'].to_i)
    @predictions = @location.predictions(params['period'].to_i)
  end
end
