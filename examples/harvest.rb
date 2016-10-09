require 'nokogiri'

# Queries weather station data provided by harvestelectronics.com
class Harvest
  include UseCasePattern

  validates :station_id, presence: true

  def initialize(station_id:)
    @station_id = station_id.to_i
  end

  def perform
    run_query
    parse_response
  end

  attr_reader :temperature, :wind_speed, :wind_direction, :wind_gust, :wind_compass, :recorded_at

  private

  def parse_response
    document = Nokogiri::HTML(@response_body)

    @temperature = document.css('#temp').first.content.strip[0..-3]
    @wind_speed = document.css('#windspd').first.content.strip.match(/[\d\.]+/)
    @wind_direction = document.css('#windspd').first.content.strip.match(/Wind\s([NESW]+)\s.*/)[1]
    @wind_gust = document.css('#windgust').first.content.strip.match(/Gust\s([\d\.]+)km\/h/)[1]
    @recorded_at = Time.strptime(document.css('#title').first.content.strip, 'Weather at %H:%M %a %e %b %Y')
    @wind_compass = case @wind_direction
    when 'N' then 0
    when 'NNE' then 23
    when 'NE' then 45
    when 'ENE' then 68
    when 'E' then 90
    when 'ESE' then 113
    when 'SE' then 135
    when 'SSE' then 158
    when 'S' then 180
    when 'SSW' then 203
    when 'SW' then 225
    when 'WSW' then 248
    when 'W' then 270
    when 'WNW' then 293
    when 'NW' then 315
    when 'NNW' then 338
    end
  end

  def host
    'harvestelectronics.com'
  end

  def query_string
    "/w.cgi?hsn=#{@station_id}&cmd=cwc"
  end

  def run_query
    http = Net::HTTP.new(host)
    response = http.request(Net::HTTP::Get.new(query_string))

    if response.code != "200"
      $stderr.puts "Harvest error (status-code: #{response.code})\n#{response.body}"

      @response_body = nil
    else
      @response_body = response.body
    end
  end
end
