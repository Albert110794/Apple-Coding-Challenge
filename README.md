# README - Weather Forecast App

This is a Ruby on Rails application that retrieves weather forecast data for a given address and displays it to the user. The forecast data includes the current temperature and can also include high/low and/or extended forecast details, if available.


## Installation
1. Clone this repository to your local machine.

2. Run `bundle install` to install the required dependencies.

3. Create a `config/credentials.yml.enc` file in the project and add your API key as follows:
- In the terminal, run the following command to create or edit the credentials file:

  `rails credentials:edit`
  
- This will open up the credentials file in your default editor. 
  Add the following line to the file:
  
  `open_weather_map_api_key: your_api_key_here`
  
  Save and Close the file
  
- In code, replace the line with the API key:

  `api_key = Rails.application.credentials.open_weather_map_api_key`
  
Note: You will need to obtain an API key from a weather service provider such as OpenWeatherMap or WeatherAPI.  
  
## Usage

To run the application, use the following command:

`rails server`

Once the server is running, you can access the application at http://localhost:3000.

To retrieve weather forecast data for an address, enter the address in the search bar and click the "Get Forecast" button. 
The application will retrieve the current temperature for the given address and display it to the user.

If high/low and/or extended forecast data is available, it will also be displayed. 
If the result is pulled from cache, an indicator will be displayed to let the user know.

The application caches forecast details for 30 minutes for all subsequent requests by zip codes.

## Contributing

Bug reports and pull requests are welcome on GitHub at my branch. 

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant code of conduct.

## License

This application is available as open source under the terms of the [MIT License](https://opensource.org/license/mit/).



