class Nest
  attr_accessor :status
  attr_accessor :id

  def initialize(id, status)
    self.id = id
    self.status = status
  end

  def wheres
    self.status['where']
  end

  def device
    self.status['device'][self.id]
  end

  def shared
    self.status['shared']
  end

  def weather
    @weather ||= Weather.new(self.zip)
  end

  def on?
    if shared[self.id]['target_temperature_type'] == 'cool'
      shared[self.id]['hvac_ac_state']
    else
      shared[self.id]['hvac_heater_state']
    end
  end

  def temperature
    to_fahrenheit(shared[self.id]['current_temperature'])
  end

  def target_temperature
    to_fahrenheit(shared[self.id]['target_temperature'])
  end

  def zip
    device['postal_code']
  end

  def name
    @lookup_table ||= Hash[*(wheres.values.first['wheres'].map{|hash| hash.values}.flatten)]
    @lookup_table[device['where_id']]
  end

  def report!
    if self.on?
      puts "Stat'ing that we're on"
      StatHat::API.ez_post_count("#{self.name} on", credentials['stathat']['key'], 1)
    end

    puts "Stat'ing delta"
    StatHat::API.ez_post_value("#{self.name} delta", credentials['stathat']['key'], (self.target_temperature - self.temperature).abs)
  end

  private
  def to_fahrenheit(celsius)
    (celsius * (9/5.0)).to_i + 32
  end
end

