class DataAnalysis
  attr_reader :coeffs, :constant, :r2

  # x_data is an array
  # y_data is an array, with y_data[i] corresponds to x_data[i]
  def initialize(x_data, y_data)
    @x_data = x_data
    @y_data = y_data
    @coeffs = nil
    @constant = nil
    @r2 = nil
    @best_eq = nil
    @best_eq_r2 = nil
  end

  # eq: y = @coeffs['x']x + @constant
  def analyse_linear!
    analyse! prepare_linear
  end

  # eq: y = @coeffs['x1']x^1 + @coeffs['x2']x^2 + @coeffs['x3']x^3 + ... + @constant
  def analyse_poly!
    analyse! prepare_poly(fittest_poly_degree)
  end

  # eq: y = @coeffs['x1']x^1 + .. + @coeffs["x#{degree}"]x^degree + @constant
  def analyse_poly_with_degree!(degree)
    analyse! prepare_poly(degree)
  end

  # eq: y = @coeffs['A']*e^(@coeffs['B']x)
  def analyse_exp!
    expo_regression!
  end

  # eq: y = @coeffs['xlog']ln(x) + @constant
  def analyse_log!
    analyse! prepare_log
  end

  def best_equation
    best_r2 = 0

    analyse_linear!
    if @r2 > best_r2
      best_r2 = @r2
      coef_x = @coeffs['x']
      const = @constant
      @best_eq = Proc.new { |x| coef_x*x + const }
      @best_eq_r2 = @r2
    end

    begin
      analyse_poly!
    rescue Exception
    end
    if @r2 > best_r2
      best_r2 = @r2
      poly_cos = @coeffs.dup
      const = @constant
      @best_eq = Proc.new do |x|
        result = 0
        poly_cos.keys.each do |key|
          result += poly_cos[key] * (x ** key[1..-1].to_i)
        end
        result += const
      end
      @best_eq_r2 = @r2
    end

    begin
      analyse_exp!
    rescue Exception
    end
    if @r2 > best_r2
      best_r2 = @r2
      coef_a = @coeffs['A']
      coef_b = @coeffs['B']
      @best_eq = Proc.new { |x| coef_a * Math.exp(coef_b * x) }
      @best_eq_r2 = @r2
    end

    begin
      analyse_log!
    rescue Exception
    end
    if @r2 > best_r2
      best_r2 = @r2
      coe_log = @coeffs['xlog']
      const = @constant
      @best_eq = Proc.new { |x| coe_log * Math.log(x) + const }
      @best_eq_r2 = @r2
    end

    @best_eq
  end

  # Return the extrapolated value, and the r-square value for the best-fit equation used
  def extrapolate(x)
    @best_eq ||= best_equation
    [@best_eq.call(x), @best_eq_r2]
  end

  # calculate the R-squared value of this dataset to measure the fitness of the given equation
  # the given equation has to be a callable object that takes in an argument 'x' and mapping that to the expected y value
  # equation given in http://en.wikipedia.org/wiki/Coefficient_of_determination
  def self.r_square(x_array, y_array, equation)
    raise "lengths of x_array and y_array do not match" if x_array.length != y_array.length
    expected_y_array = x_array.map {|x| equation.call(x)}
    y_mean  = y_array.reduce(:+).to_f/y_array.length
    ss_res = 0
    ss_tot = 0

    x_array.length.times do |i|
      ss_res += (y_array[i] - expected_y_array[i])**2
      ss_tot += (y_array[i] - y_mean)**2
    end

    1 - (ss_res.to_f/ss_tot)
  end

  # private

    def prepare_linear
      x = @x_data.to_scale
      y = @y_data.to_scale
      dataset = {'x'=>x,'y'=>y}.to_dataset
    end

    def prepare_poly(degree)
      data_hash = {}
      data_hash['y'] = @y_data.to_scale
      degree.times do |pow|
        data_hash["x#{pow+1}"] = @x_data.map {|num| num ** (pow+1)}.to_scale
      end
      dataset = data_hash.to_dataset
    end

    def fittest_poly_degree
      max_degree = 5
      max_r2 = 0
      best_degree = nil
      (2..max_degree).to_a.each do |degree|
        r2 = analyse! prepare_poly(degree)
        if r2 > max_r2
          max_r2 = r2
          best_degree = degree
        end
      end
      best_degree
    end

    # Exponential regression on the data; solving for a equation in the format of "y = Ae^(Bx)"
    # Saving values of 'A' and 'B' into coeffs
    # Algorithm derived from the equations given in
    #   http://mathworld.wolfram.com/LeastSquaresFittingExponential.html
    def expo_regression!
      n = @x_data.length
      x2_sum = 0
      x_sum = 0
      xlny_sum = 0
      lny_sum = 0

      @x_data.length.times do |i|
        x_sum += @x_data[i]
        x2_sum += @x_data[i]**2
        xlny_sum += @x_data[i] * Math.log(@y_data[i])
        lny_sum += Math.log(@y_data[i])
      end

      a = (lny_sum * x2_sum - x_sum * xlny_sum)/ (n * x2_sum - x_sum**2)
      b = (n * xlny_sum - x_sum * lny_sum)/ (n * x2_sum - x_sum**2)

      @coeffs = {}
      @coeffs['A'] = Math.exp(a)
      @coeffs['B'] = b
      @r2 = DataAnalysis.r_square(@x_data, @y_data, lambda{|x| Math.exp(a) * Math.exp(b*x)})
    end

    def prepare_log
      xlog = @x_data.map {|num| Math::log(num)}.to_scale
      y = @y_data.to_scale
      dataset = {'xlog'=>xlog,'y'=>y}.to_dataset
    end

    # do regression on the dataset, using 'y' as the dependent value
    def analyse!(ds)
      analysis = Statsample::Regression.multiple(ds,'y')
      @coeffs = analysis.coeffs
      @constant = analysis.constant
      @r2 = analysis.r2
    end
end
