require 'rails_helper'
require 'webmock/rspec'

RSpec.describe ForecastsController, type: :controller do
  describe 'GET #show' do
    context 'when given a valid address' do
      let(:valid_address) { 'Seattle, WA' }
      let(:api_key) { 'valid_api_key' }

      before do
        allow(Rails.application.credentials).to receive(:open_weather_map_api_key).and_return(api_key)
        url = "https://api.openweathermap.org/data/2.5/weather?q=#{URI.encode_www_form_component(valid_address)}&appid=#{api_key}&units=imperial"
        stub_request(:get, url).
          to_return(status: 200, body: '{"name": "Seattle", "main": {"temp": 50}, "wind": {"speed": 10, "deg": "test deg"}}', headers: {})
        stub_request(:get, "https://api.openweathermap.org/data/2.5/forecast?appid=valid_api_key&q=Seattle,%20WA&units=imperial").
          to_return(status: 200, body: '{"list": []}', headers: {})
        get :show, params: { address: valid_address }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns the temperature' do
        expect(assigns(:temperature)).to eq(50)
      end

      it 'assigns the humidity' do
        expect(assigns(:humidity)).to be_nil
      end

      it 'assigns the pressure' do
        expect(assigns(:pressure)).to be_nil
      end

      it 'assigns the wind speed' do
        expect(assigns(:wind_speed)).not_to be_nil
      end

      it 'assigns the wind direction' do
        expect(assigns(:wind_direction)).not_to be_nil
      end

      it 'assigns the forecast' do
        expect(assigns(:forecast)).not_to be_nil
      end

      it 'assigns the high temperatures' do
        expect(assigns(:high_temperatures)).to be_empty
      end

      it 'assigns the low temperatures' do
        expect(assigns(:low_temperatures)).to be_empty
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end

    context 'when given an invalid address' do
      let(:invalid_address) { 'Invalid Address' }
      let(:api_key) { 'valid_api_key' }

      before do
        allow(Rails.application.credentials).to receive(:open_weather_map_api_key).and_return(api_key)
        url = "https://api.openweathermap.org/data/2.5/weather?q=#{URI.encode_www_form_component(invalid_address)}&appid=#{api_key}&units=imperial"
        stub_request(:get, url).to_return(status: 404, body: '', headers: {})
        get :show, params: { address: invalid_address }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets an error flash message' do
        expect(flash[:error]).to eq("Unable to retrieve weather forecast for #{invalid_address}.")
      end
    end
  end
end
