json.latitude "#{@lat}"
json.longtitude "#{@long}"

json.predictions do
  @predictions.each_index do |i|
    json.set! i do
      json.time "#{@predictions[i].time.strftime("%R %d-%m-%Y")}"
      json.rain do
        json.value "#{@predictions[i].rain.amount.round(2)}mm"
        json.probability "#{@predictions[i].rain.prob.round(2)}"
      end
      json.temp do
        json.value "#{@predictions[i].temperature.value.round(2)}"
        json.probability "#{@predictions[i].temperature.prob.round(2)}"
      end
      json.wind do
        json.direction "#{@predictions[i].wind.dir}"
        json.speed "#{@predictions[i].wind.speed.round(2)}"
        json.probability "#{@predictions[i].wind.prob.round(2)}"
      end
    end
  end
end
