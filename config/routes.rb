Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "homes#top"
  get 'home/about' => 'homes#about', as: 'about'

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationship, only: [:create, :destroy]
    resources :followers, only: [:create, :destroy]
    resources :followeds, only: [:create, :destroy]
    get 'followers', to: 'users#followers', as: 'user_followers'
    get 'followeds', to: 'users#followeds', as: 'user_followeds'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
