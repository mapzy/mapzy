# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users,
    path: 'account',
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

  authenticated :user do
    root to: 'maps#index', as: :authenticated_root
  end

  resources :dashboard, only: [:index]

  scope module: 'dashboard' do
    resources :maps
    resources :locations
  end

  # Tmp
  get '/maps_test' => 'maps#maps_test'
end
