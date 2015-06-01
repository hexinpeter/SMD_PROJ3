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

    isBadPostCode = false
    if @location_id.to_i < 3000 || (@location_id.to_i > 3999 && @location_id.to_i < 10000)
      isBadPostCode == true
    end

    if !isPostCode

      if @location_id.to_i < 3000 && @location_id.to_i > Location.all.length || (@location_id.to_i > 3999 && @location_id.to_i < 10000)
        return
      end

      @my_locations = Location.where(ref_code: @location_id)[0]
      @my_records = []
      if @my_locations == nil
        @all_records ==[]
        return
      else
        @all_records = @my_locations.records
      end

      @all_records.each do |record|
        temp = @date.scan(/-/)
        if temp.length == 2 #record.time.strftime('%d-%m-%Y').equal? @date
          @in = true
          @my_records << record
        end
      end


    else
      @my_post_code = params["location_id"]
      @all_locations = Location.all
      @my_locations = []

      @all_locations.each do |location|
        if location.post_code.num ==  @my_post_code
          @my_locations << location
        end

      end

      render :show_area
    end

  end


  def show_area

  end
end
