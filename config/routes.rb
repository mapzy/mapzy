# frozen_string_literal: true

Rails.application.routes.draw do
  devise_scope :user do
    authenticated do
      root to: 'dashboard/maps#index', as: :authenticated_root_url
    end
    unauthenticated do
      root to: 'home#index'
    end
  end

  devise_for :users,
    path: 'account',
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

  resources :maps, only: [:index, :show]
  resources :locations

  namespace :dashboard do
    resources :maps, only: [:index, :show]
    resources :locations
  end

  if Rails.env.development?
    namespace :development do
      resources :design, only: [:index]
      resources :embed_mock, only: [:index]
    end
  end
end
