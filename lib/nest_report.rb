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
    header = "ID, Name, Temperature, Target Temperature, Running, Zip, Outdoor Temperature, Humidity"

    devices.first.tap do |device|
      puts "Stat'ing temp"
      StatHat::API.ez_post_value("#{device.name} temperature", credentials['stathat']['key'], device.weather.temperature)
      StatHat::API.ez_post_value("#{device.name} humidity", credentials['stathat']['key'], device.weather.humidity)
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
        device.weather.humidity
      ].join(", ")
    end.join("\n")
    [header, csv].join("\n")
  end
end

