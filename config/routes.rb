Rails.application.routes.draw do
  resources :registration_form, only: [:show, :update]
  resources :parents, only: [:show]
  resources :campers, only: [:index, :show]
  resources :registrations, only: [:index]
end
