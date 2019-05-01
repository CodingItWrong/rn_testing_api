Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  resources :widgets, only: %i(index)
end
