class ThingSpeakReporter
  include UseCasePattern

  def initialize(api_key:, params: {})
    @api_key = api_key
    @params = params
  end

  def perform
    post_data
    check_response
  end

  private

  attr_reader :params, :api_key, :response

  def post_data
    uri = URI("https://api.thingspeak.com/update.json")
    @response = Net::HTTP.post_form(uri, request_params)
  end

  def check_response
    if response.code != '200'
      errors.add(:base, "Non 200 response #{response.code}: #{response.body}")
    end
  end

  def request_params
    params.merge(api_key: api_key)
  end
end

# example usage

reporter = ThingSpeakReporter.perform(api_key: 'XZY123', params: {indoor_temperature: 22, outdoor_temperature: 15})

if reporter.success?
  puts "Temperature saved"
else
  puts "Oh dear, there is a problem: #{reporter.errors.full_messages.join('; ')}"
end
