Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :notifications, only: [:index]

  resource :profile, only: [:show, :edit], path: '/:username' do 
    resources :posts, except: [:index] do
      resources :likes, only: [:create, :destroy]
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
    resources :friend_requests, only: [:create, :destroy]
    resources :friends, only: [:index]
  end

  namespace :requests do
	 resources :sent_requests, only: [:index]
	 resources :received_requests, only: [:index]
	end

  resources :friendships, only: [:create, :destroy]

  root 'home#index'
end
