class DataController < ApplicationController
  def locations
    @date = Date.today
    @locations = Location.all
  end

  def show
  end

  def show_area
  end
end
