# frozen_string_literal: true

Rails.application.routes.draw do
  mount Lines::Engine => "/blog"
  use_doorkeeper


  devise_for :accounts, controllers: {sessions: :sessions,
                                      confirmations: :confirmations,
                                      registrations: :registrations,
                                      unlocks: :unlocks,
                                      passwords: :passwords},
                        path: "/accounts",
                        path_names: {sign_in: 'login',
                                     password: 'forgot',
                                     confirmation: 'confirm',
                                     unlock: 'unlock',
                                     sign_up: 'register',
                                     sign_out: 'logout'
                                     }
  devise_scope :account do
    match '/accounts/login/confirm', to: 'sessions#confirm', via: %i[get post], as: 'account/login', action: 'confirm'
    match '/accounts/register/confirm', to: 'registrations#confirm', via: %i[get post], as: 'account/register', action: 'confirm'
    match '/accounts/logout', to: 'sessions#destroy', via: %i[get], as: 'account/logout', action: 'destroy'
#    match '/accounts/forgot', to: 'passwords#update', via: %i[put patch], as: 'account/forgot'
#    match '/accounts/forgot', to: 'passwords#create', via: %i[post], as: 'account/forgot'
#    match '/accounts/forgot/new', to: 'passwords#new', via: %i[get post], as: 'account/forgot', action: 'new'
#    match '/accounts/forgot/edit', to: 'passwords#edit', via: %i[get post], as: 'account/forgot', action: 'edit'
#    match '/register/create', to: 'registrations#create', via: %i[get post]
#    match '/register', to: 'registrations#new', via: %i[get post]
    match '/accounts/unlock', to: 'unlocks#show', via: %i[get post]

    match '/accounts/sign_in', to: 'sessions#new', via: %i[get], as: 'new_account_sign_in', action: 'new'
    match '/accounts/sign_in', to: 'sessions#create', via: %i[post], as: 'account/sign_in', action: 'create'
    match '/accounts/sign_in/confirm', to: 'sessions#confirm', via: %i[get post], as: 'confirm_account_sign_in', action: 'confirm'
    match '/accounts/sign_up', to: 'registrations#new', via: %i[get post], as: 'new_account_sign_up', action: 'new'
    match '/accounts/sign_up/confirm', to: 'registrations#confirm', via: %i[get post], as: 'account/sign_up', action: 'confirm'
    match '/accounts/sign_out', to: 'sessions#destroy', via: %i[get], as: 'account/sign_out', action: 'destroy'
    match '/accounts/password', to: 'passwords#update', via: %i[put patch], as: 'update_accounts_password'
    match '/accounts/password', to: 'passwords#create', via: %i[post], as: 'create_accounts_password'
    match '/accounts/password/new', to: 'passwords#new', via: %i[get post], as: 'new_accounts_password', action: 'new'
    match '/accounts/password/edit', to: 'passwords#edit', via: %i[get post], as: 'edit_accounts_password', action: 'edit'
    match '/accounts/confirmation/new', to: 'sessions#new', via: %i[get post], as: 'new_accounts_confirmation', action: 'new'
    match '/accounts/confirmation', to: 'sessions#create', via: %i[post], as: 'create_accounts_confirmation'
    match '/accounts/confirmation', to: 'sessions#show', via: %i[get], as: 'accounts/confirmation'
  end

#  post '/register', to: 'registrations#new', as: :registation
  # root to: 'index#index', as: :index

  scope :users do
    mount UserApi::Base, at: '/api'
    mount ManagementAPI::V1::Base, at: '/management_api'

    get '/', to: 'index#index', as: :index
    post 'phones/verification', to: 'phones#verify'

    get 'security', to: 'security#enable'
    post 'security/confirm', to: 'security#confirm'

    get 'health/alive', to: 'health#alive'
    get 'health/ready', to: 'health#ready'
    get 'welcome/disable_account', to: redirect('member/:id/disable_account')

    resources :phones, only: %i[new create]
    resources :profiles, only: %i[new create]
    resources :documents, only: %i[new create]

    namespace :admin do
      get '/', to: 'accounts#index', as: :accounts
      resources :accounts, except: %i[new create] do
        post :disable_2fa, on: :member

        resources :labels, except: %i[index show]
      end
      resources :websites
      resources :profiles, only: %i[edit update] do
        put :document_label, on: :member
      end
    end
  end

end
