class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = @book.id
    comment.save
    redirect_to book_path(@book)
  end

  def destroy
    @book = BookComment.find_by(params[:book_id])
    if @book
      @book.destroy
      redirect_to book_path(params[:book_id])
    else
      flash[:error] = "指定されたコメントが見つかりませんでした。"
      redirect_to book_path(params[:book_id])
    end
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment, :book_id, :user_id)
  end
end
