class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]
  def show
    @book = Book.find(params[:id])
    @booknew = Book.new
    @book_comment = BookComment.new
  end

  def index
    to = Time.current.at_end_of_day
    #現在の日時を基準にして期間の終了日を設定します。
    from = (to - 6.day).at_beginning_of_day
    #終了日から6日前の日時を開始日として設定します。これにより、1週間の期間が設定されます。
    @books = Book.includes(:favorites).sort_by { |book| -book.favorites.where(created_at: from...to).count }
    # N+1問題を解決するために Book モデルに関連するいいね情報を一括で取得するために使用します。
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
    params.require(:book).permit(:title, :user_id, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
