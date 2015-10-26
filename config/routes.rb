Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: :sessions,
    registrations: :registrations,
    confirmations: :confirmations
  }
  devise_scope :user do
    get 'sessions/valid', to: 'sessions#valid'
  end
  root 'home#index'

  resources :trips, only: [:index, :create, :update, :destroy]
end
