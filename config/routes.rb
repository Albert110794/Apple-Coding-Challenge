Rails.application.routes.draw do
  root 'forecasts#index'
  get '/forecasts', to: 'forecasts#show'
end
