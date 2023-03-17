require 'httparty'
require 'open-uri'

class ForecastsController < ApplicationController
  def show
    address = params[:address]

    # Check cache for existing forecast data
    forecast = Rails.cache.fetch(address, expires_in: 30.minutes) do
      # If no cached data exists, fetch forecast data from API
      @api_key = Rails.application.credentials.open_weather_map_api_key
      url = "https://api.openweathermap.org/data/2.5/weather?q=#{URI.encode_www_form_component(address)}&appid=#{@api_key}&units=imperial"
      response = HTTParty.get(url)
      JSON.parse(response.body) if response.success?
    end

    if forecast.present?
      @temperature = forecast['main']['temp']
      @humidity = forecast['main']['humidity']
      @pressure = forecast['main']['pressure']
      @wind_speed = forecast['wind']['speed']
      @wind_direction = forecast['wind']['deg']

      # Get the forecast for the next 5 days (including today)
      forecast_url = "https://api.openweathermap.org/data/2.5/forecast?q=#{URI.encode_www_form_component(address)}&appid=#{@api_key}&units=imperial"
      forecast_response = HTTParty.get(forecast_url)
      if forecast_response.success?
        forecast_data = JSON.parse(forecast_response.body)
        @forecast = forecast_data['list']

        # Find the high and low temperatures for the next 5 days
        @high_temperatures = []
        @low_temperatures = []
        @forecast.each do |forecast|
          temperature = forecast['main']['temp']
          if @high_temperatures.empty? || temperature > @high_temperatures.last
            @high_temperatures << temperature
          end
          if @low_temperatures.empty? || temperature < @low_temperatures.last
            @low_temperatures << temperature
          end
        end
      end

      # Set cache indicator
      @from_cache = Rails.cache.exist?(address)

      # Cache the forecast data for subsequent requests
      Rails.cache.write(address, forecast, expires_in: 30.minutes)

      render 'show'
    else
      flash[:error] = "Unable to retrieve weather forecast for #{address}."
      redirect_to root_path
    end
  end
end
