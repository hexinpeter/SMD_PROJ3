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
    if @location_id.to_i < 3000 || @location_id.to_i > 3999
      isBadPostCode == true
    end

    if !isPostCode

      if @location_id.to_i < 3000 && @location_id.to_i > Location.all.length || @location_id.to_i > 3999
        return
      end

      @my_locations = Location.where(id: @location_id)[0]
      @all_records = @my_locations.records
      @my_records = []
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
      # redirect_to :controller => "data", :action => "show_area", :post_code => "#{@location_id}", :date => "#{@date}"
      # redirect_to  url_for(:controller => :data, :action => :show_area, :params => :date, :params => :location_id)
    end

  end


  def show_area

    # @post_code = params["location_id"]
    # @date = params["date"]

    # @my_locations = Location.find_closest_with_postcode(@postcode)
    # @my_records = []
    #
    # @my_locations.records do |record|
    #   if record.time.strftime('%d-%m-%Y') == @date
    #     @my_records << record
    #   end
    # end









  end
end
