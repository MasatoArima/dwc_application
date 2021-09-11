Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  get 'home/about' => 'homes#about'
  
  resources :users,only: [:show,:index,:edit,:update]
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