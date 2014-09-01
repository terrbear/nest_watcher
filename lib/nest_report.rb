require 'nest_thermostat'
require 'stathat'

class NestReport
  def initialize
    @api = NestThermostat::Nest.new(email: credentials['nest']['username'], password: credentials['nest']['password'])
  end

  def status
    @status ||= @api.status
  end

  def devices
    self.status['device']
  end

  def report
    devices = self.devices.map{|id, device| Nest.new(id, self.status)}
    #Headers: ID, Name, Temperature, Target Temperature, Running, Zip, Outdoor Temperature, Humidity, Time

    devices.first.tap do |device|
      if stats_enabled?
        StatHat::API.ez_post_value("temperature", credentials['stathat']['key'], device.weather.temperature)
        StatHat::API.ez_post_value("humidity", credentials['stathat']['key'], device.weather.humidity)
      end
    end

    csv = devices.map do |device|
      device.report!
      [
        device.id, 
        device.name,
        device.temperature,
        device.target_temperature,
        device.on?,
        device.zip,
        device.weather.temperature,
        device.weather.humidity,
        Time.now
      ].join(", ")
    end.join("\n")
  end
end

