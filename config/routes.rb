# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
    path: 'account',
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }
  resources :maps
end
