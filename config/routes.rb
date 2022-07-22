# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  devise_scope :user do
    authenticated do
      root to: "dashboard/maps#index", as: :authenticated_root_url
    end
    unauthenticated do
      root to: "users/sessions#new"
    end
  end

  devise_for \
    :users,
    path: "account",
    path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords"
    }

  resources :maps, only: %i[index show] do
    resources :locations, only: %i[index show]
  end

  namespace :dashboard do
    resources :maps, only: %i[index show update] do
      resources :locations
      resources :location_imports, only: %i[new create]
    end

    get "/settings", to: "accounts#settings", as: "account_settings"
    get "/embed", to: "accounts#embed", as: "account_embed"
  end

  namespace :api do
    namespace :v1 do
      post "/maps/:map_id/sync", to: "maps#sync", as: "maps_sync"
    end
  end

  scope "/stripe" do
    get "/checkout_session/", to: "stripe#checkout_session", as: "stripe_checkout_session"
    get "/success_callback/", to: "stripe#success_callback", as: "stripe_success_callback"
    get "/customer_portal/", to: "stripe#customer_portal", as: "stripe_customer_portal"
    post "/webhooks/", to: "stripe#webhooks", as: "stripe_webhooks"
  end

  if Rails.env.development?
    namespace :development do
      resources :design, only: [:index]
      resources :embed_mock, only: [:index]
    end
  end

  mount Sidekiq::Web => "/sidekiq"
end
