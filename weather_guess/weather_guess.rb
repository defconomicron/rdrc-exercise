require "rubygems"
require "bundler/setup"

require "uri"
require "open-uri"
require "nokogiri"
require "highline/import"

class WeatherGuess
  attr_accessor :unit_of_measure
  attr_accessor :location
  attr_accessor :answer
  attr_accessor :data
  
  def initialize(options={})
    self.unit_of_measure = options[:unit_of_measure]
    self.location        = URI.escape(options[:location])
    self.answer          = self.get_temp
  end
  
  def is_match?(temp)
    self.answer == temp
  end
  
  def guess(temp)
    if is_match?(temp)
      "You are right"
    else
      "You are wrong: #{self.answer}"
    end
  end
  
  def get_data
    url = "http://www.google.com/ig/api?weather=#{self.location}"
    
    data = Nokogiri::XML(open(url))
  end
  
  def get_temp
    get_data.xpath('/xml_api_reply/weather/current_conditions/temp_f').first.attribute('data').value.to_i
  end
end


begin
  location = ask("Enter your location:  ")
  my_guess = ask("Enter your guess:  ").to_i
  
  weather_guess = WeatherGuess.new(:location => location)
  
  puts weather_guess.guess(my_guess)
rescue Exception => e
  puts "An error occurred: #{e.message}"
end
  