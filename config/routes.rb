# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  authenticated :user do
    root to: 'maps#index', as: :authenticated_root
  end

  devise_for :users,
    path: 'account',
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

  resources :dashboard, only: [:index]

  scope module: 'dashboard' do
    resources :maps
    resources :locations
  end

  if Rails.env.development?
    namespace :development do
      resources :design, only: [:index]
    end
  end
end
