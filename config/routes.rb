Rails.application.routes.draw do
  get 'parents/show'

  get 'registration/index'

  resources :campers, only: [:index, :show]
  resources :parents, only: [:show]
  resources :registrations, only: [:index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
