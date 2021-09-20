class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @today_book =  @books.created_today
    @yesterday_book = @books.created_one_day_ago
    @two_day_ago_book = @books.created_two_day_ago
    @three_day_ago_book = @books.created_three_day_ago
    @four_day_ago_book = @books.created_four_day_ago
    @five_day_ago_book = @books.created_five_day_ago
    @six_day_ago_book = @books.created_six_day_ago
    gon.post_list = []
    gon.post_list.push(@six_day_ago_book.count)
    gon.post_list.push(@five_day_ago_book.count)
    gon.post_list.push(@four_day_ago_book.count)
    gon.post_list.push(@three_day_ago_book.count)
    gon.post_list.push(@two_day_ago_book.count)
    gon.post_list.push(@yesterday_book.count)
    gon.post_list.push(@today_book.count)
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week

    @book = Book.new
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "users/edit"
    end
  end

  def search
    @book_date = Book.new(book_date_params)
    @user = User.find(params[:id])
    @books = @user.books
  end

  private

  def book_date_params
    params.require(:book).permit(:created_at)
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
