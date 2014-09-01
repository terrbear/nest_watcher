require 'weather_underground'

class Weather
  def initialize(zip)
    @api = WeatherUnderground::Base.new(credentials['weather_underground']['key'])
    @zip = zip
  end

  def forecast
    @forecast ||= @api.forecast(@zip)
  end

  def temperature
    self.forecast['current_observation']['temp_f']
  end

  def humidity
    self.forecast['forecast']['simpleforecast']['forecastday'].first['avehumidity']
  end
end
