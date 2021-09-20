class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    if @book.user_id != current_user.id
      @book = Book.find(params[:id])
      impressionist(@book)
    end
    @book = Book.find(params[:id])
    @user = User.find(@book.user_id)
    @newbook = Book.new
    @book_comment = BookComment.new
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
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.search(params[:search])
    if params[:search] == nil
      if params[:category] != nil
        @books = Book.search(params[:category])
      elsif params[:option] == "B"
        @books = Book.order('created_at DESC')
      elsif params[:option] == "C"
        @books = Book.order('rate DESC')
      elsif
        params[:option] == "A" || params[:option] == nil
        @books = Book.includes(:favorited_users).
          sort {|a,b|
            b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
            a.favorited_users.includes(:favorites).where(created_at: from...to).size
          }
      end
    end
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user_id != current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate, :category)
  end

end
