Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  get 'home/about' => 'homes#about'
  get 'search' => 'searches#search'

  resources :users,only: [:show,:index,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
              # book_book_comments  POST   /books/:book_id/book_comments(.:format)          book_comments#create
              # book_book_comment   DELETE /books/:book_id/book_comments/:id(.:format)      book_comments#destroy
    # resource :book_comments, only: [:create, :destroy]
              # book_book_comments  DELETE /books/:book_id/book_comments(.:format)          book_comments#destroy
              #                     POST   /books/:book_id/book_comments(.:format)          book_comments#create

  end
end