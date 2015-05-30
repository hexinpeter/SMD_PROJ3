class DataController < ApplicationController
  def locations
    @date = Date.today
    @locations = Location.all
  end


  def show
    @location_id = params["location_id"]
    @date = params["date"]

    isPostCode = false
    PostCode.all.each do |postcode|
      if @location_id == postcode.num
        isPostCode = true
        break
      end
    end

    if !isPostCode
      @my_location = Location.where(id: @location_id)[0]
      @all_records = @my_location.records
      @my_records = []
      @all_records.each do |record|
        temp = @date.scan(/-/)
        if temp.length == 2 #record.time.strftime('%d-%m-%Y').equal? @date
          @in = true
          @my_records << record
        end
      end

    else
      render :show_area
      # redirect_to  url_for(:controller => :data, :action => :show_area, :params => :date, :params => :location_id)
    end

  end


  def show_area

    @post_code = params["location_id"]
    @date = params["date"]

    @my_locations = Location.all.where(post_code: @post_code)









  end
end
