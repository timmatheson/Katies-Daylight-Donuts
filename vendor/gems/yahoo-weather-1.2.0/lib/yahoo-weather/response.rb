# Describes the weather conditions for a particular requested location.
class YahooWeather::Response
  # a YahooWeather::Astronomy object detailing the sunrise and sunset
  # information for the requested location.
  attr_reader :astronomy

  # a YahooWeather::Location object detailing the precise geographical names
  # to which the requested location was mapped.
  attr_reader :location

  # a YahooWeather::Units object detailing the units corresponding to the
  # information detailed in the response.
  attr_reader :units

  # a YahooWeather::Wind object detailing the wind information at the
  # requested location.
  attr_reader :wind

  # a YahooWeather::Atmosphere object detailing the atmosphere information
  # of the requested location.
  attr_reader :atmosphere

  # a YahooWeather::Condition object detailing the current conditions of the
  # requested location.
  attr_reader :condition

  # a list of YahooWeather::Forecast objects detailing the high-level
  # forecasted weather conditions for upcoming days.
  attr_reader :forecasts

  # the raw HTML generated by the Yahoo! Weather service summarizing current
  # weather conditions for the requested location.
  attr_reader :description

  # a YahooWeather::Image record describing an image icon
  # representing the current weather.
  attr_reader :image

  # the latitude of the location for which weather is detailed.
  attr_reader :latitude

  # the longitude of the location for which weather is detailed.
  attr_reader :longitude

  # a link to the Yahoo! Weather page with full detailed information on the
  # requested location's current weather conditions.
  attr_reader :page_url

  # the location string initially requested of the service.
  attr_reader :request_location

  # the url with which the Yahoo! Weather service was accessed to build the response.
  attr_reader :request_url

  # the prose descriptive title of the weather information.
  attr_reader :title

  def initialize (request_location, request_url, doc)
    # save off the request params
    @request_location = request_location
    @request_url = request_url
    
    doc.symbolize_keys!

    # parse the nokogiri xml document to gather response data
    root = doc[:rss]["channel"]
    
    @astronomy = YahooWeather::Astronomy.new(root['yweather:astronomy'])
    @location = YahooWeather::Location.new(root['yweather:location'])
    @units = YahooWeather::Units.new(root['yweather:units'])
    @wind = YahooWeather::Wind.new(root['yweather:wind'])
    @atmosphere = YahooWeather::Atmosphere.new(root['yweather:atmosphere'])
    @image = YahooWeather::Image.new(root['image'])

    item = root["item"]
    puts item.inspect
    @condition = YahooWeather::Condition.
      new(item['yweather:condition'])
    @forecasts = []
    item['yweather:forecast'].each { |forecast| 
      @forecasts << YahooWeather::Forecast.new(forecast) }
    @latitude = item['geo:lat'].to_f
    @longitude = item['geo:long'].to_f
    @page_url = item['link']
    @title = item['title']
    @description = item['description']
  end
end
