Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  get 'home/about' => 'homes#about'
  get 'search' => 'searches#search'

  resources :users,only: [:show,:index,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    collection do
      get '/:id/search', to: 'users#search', as: 'search'
    end
  end

  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :messages, only: [:create]
  resources :rooms, only: [:create,:show]
  resources :groups do
    collection do
      get '/:id/add_user', to: 'groups#add_user', as: 'add_user'
      get '/:id/destroy_user', to: 'groups#destroy_user', as: 'destroy_user'
    end
  end
end