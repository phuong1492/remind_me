require "forecast_io"
require "twilio-ruby"
require "pry"
# Get weather info
ForecastIO.configure do |c|
  c.api_key = ENV["FORECAST_KEY"]
end

def get_today_weather
  totay = Time.now.strftime("%d-%m-%Y")
  weather_info = ForecastIO.forecast(35.752804,139.733481,params: { units:'si'})
  today_weather = weather_info["daily"]["data"].select{|x| Time.at(x["time"]).strftime("%d-%m-%Y") == totay}
  chance_of_rain = today_weather.first["precipIntensityMax"]
  summary = today_weather.first["summary"]
  if chance_of_rain > 1
    return "#{summary}. Please bring umbrella!".upcase
  else
    nil
  end
end

def get_train_status
end

def send_sms message_body
  return if message_body.nil?
  # set up a client to talk to the Twilio REST API
  @client = Twilio::REST::Client.new ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]
  @client.api.account.messages.create(
  from: ENV["FROM_NUM"],
  to: ENV["TO_NUM"],
  body: message_body
  )
end

send_sms get_today_weather()
