# encoding: UTF-8
# frozen_string_literal: true

# Explicitly require "lib/peatio.rb".
# You may be surprised why this line also sits in config/application.rb.
# The same line sits in config/application.rb to allows early access to lib/peatio.rb.
# We duplicate line in config/routes.rb since routes.rb is reloaded when code is changed.
# The implementation of ActiveSupport's require_dependency makes sense to use it only in reloadable files.
# That's why it is here.
require_dependency 'peatio'

Dir['app/models/deposits/**/*.rb'].each { |x| require_dependency x.split('/')[2..-1].join('/') }
Dir['app/models/withdraws/**/*.rb'].each { |x| require_dependency x.split('/')[2..-1].join('/') }

class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Peatio::Application.routes.draw do

  get 'symbol_detail/show/:currency' => 'symbol_detail#show'

  root 'welcome#index'

  get '/fidelitypay/deposit' => 'pay_gate_return#index'

  get '/aboutus' => 'welcome#aboutus'
  get '/login_privacy' => 'welcome#login_privacy'
  get '/login_alert' => 'welcome#login_alert'
  get '/cookies_eu' => 'welcome#cookies_eu'
  get '/invaild_browser' => 'welcome#invaild_browser'

  post 'welcome/update_profile_image'
  post 'welcome/update_profile',:path => 'update_profile'
  post 'welcome/change_pwd',:path => 'change_pwd'
  get 'welcome/approve_login',:path => 'member/:id/approve_login'
  get 'welcome/confirm_withdrawal',:path => 'member/:id/confirm_withdrawal'
  get 'welcome/disable_account',:path => 'member/:id/disable_account'

  get 'welcome/coins_info',:path => 'coins-info'
  get '/login_supportfooter' => 'welcome#login_supportfooter'
  get '/support' => 'welcome#login_supportfooter'
  get '/login_terms_cond' => 'welcome#login_terms_cond'
  get '/terms' => 'welcome#login_terms_cond'
  get '/conditions' => 'welcome#login_terms_cond'
  get '/termsandconditions' => 'welcome#login_terms_cond'
  get '/privacy' => 'welcome#login_privacy'
  get '/setmode/:mode' => 'welcome#setmode'

  get '/login' => 'sessions#callback', :as => :login
  get '/login/confirm', to: redirect('/accounts/login/confirm')
  post '/login/confirm', to: redirect('/accounts/login/confirm')
#, to: redirect{ |params, request| ["/accounts/login#{params[:login_referer_path]}", request.query_string.presence].compact.join('?') }
  get '/register', to: redirect('/accounts/register')
  get '/register/confirm', to: redirect('/accounts/register/confirm')
  get '/unlock', to: redirect('/accounts/unlock')
  get '/forgot', to: redirect('/accounts/forgot')

  get '/logout' => 'sessions#destroy', :as => :logout
  get '/auth/failure' => 'sessions#failure', :as => :failure
  match '/auth/:provider/callback' => 'sessions#create', via: %i[get post]

  scope module: :private do
    resources :rewards, only: :index

    resources :settings, only: [:index]

    resources :withdraw_destinations, only: %i[ create update ]

    resources :funds, only: [:index] do
      collection do
        post :gen_address
        get :funds_json
      end
    end

    resources :bank_details

    resources 'deposits/:currency', controller: 'deposits', as: 'deposit', only: %i[ destroy ] do
      collection {
        post 'gen_address'
        get '/',  action: :show
        post 'create_payment', action: :create_payment
      }
    end


    resources 'withdraws/:currency', controller: 'withdraws', as: 'withdraw', only: %i[ create destroy ] do
      collection {
        get '/', action: :show
      }
    end

    get '/history/orders' => 'history#orders', as: :order_history
    get '/history/trades' => 'history#trades', as: :trade_history
    get '/history/account' => 'history#account', as: :account_history
    get '/history/open_orders' => 'history#open_orders', as: :open_order_history

    resources :markets, only: [:show], constraints: MarketConstraint do
      resources :orders, only: %i[ index destroy ] do
        collection do
          post :clear
        end
      end
      resources :order_bids, only: [:create] do
        collection do
          post :clear
        end
      end
      resources :order_asks, only: [:create] do
        collection do
          post :clear
        end
      end
    end
  end

  get 'health/alive', to: 'public/health#alive'
  get 'health/ready', to: 'public/health#ready'

  get 'trading/:market_id', to: BlackHoleRouter.new, as: :trading
#  get '/exchange/:market_id', to: BlackHoleRouter.new, as: :trading

  get '/trading', to: redirect('/trading/ethbtc')
  get '/exchange', to: redirect('/trading/ethbtc')

  draw :admin

  get '/swagger', to: 'swagger#index'

  mount APIv2::Mount => APIv2::Mount::PREFIX
  mount ManagementAPIv1::Mount => ManagementAPIv1::Mount::PREFIX
end
