Rails.application.routes.draw do
  get 'trading/:market_id', to: 'markets#show'
  get '/trading', to: redirect('/trading/ethbtc')
end
