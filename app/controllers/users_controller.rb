class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @currentUserEntry = Entry.where(user_id: current_user.id) #現在ログインしているユーザーの全Entryデータを取得します
    @userEntry = Entry.where(user_id: @user.id) #@userの全Entryデータを取得します。
    unless @user.id == current_user.id #@user と current_user が別人の時
      @currentUserEntry.each do |cu|  #現在ログインしているユーザーの全Entryデータを1つずつ取り出します。
        @userEntry.each do |u|   #@userの全Entryデータを1つずつ取り出します。
          if cu.room_id == u.room_id  #現在ログインしているユーザーのEntryデータのうち、room_idが@userのEntryデータの持つroom_idと同じ時
            @isRoom = true  #現在ログインしているユーザーと@userの共通のRoomがあることを明確にしている
            @roomId = cu.room_id  #@roomIdに その現在ログインしているユーザーと@userの共通のroom_idを代入
          end
        end
      end
      if @isRoom
      else   #現在ログインしているユーザーと@userの共通のRoomがない時
        @room = Room.new  #新しい Roomと Entryを作成
        @entry = Entry.new
      end
    end
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

  def followeds
    user = User.find(params[:user_id])
    @users = user.followeds
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

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
