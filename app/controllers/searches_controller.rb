class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
      @user = params[:word]
    else
      @books = Book.looks(params[:search], params[:word])
      @book = params[:word]
    end
  end
end