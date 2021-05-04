# frozen_string_literal: true

Rails.application.routes.draw do
  resources :maps

  get '/maps_test' => 'maps#maps_test'
end
