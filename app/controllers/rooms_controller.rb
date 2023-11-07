class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_non_related, only: [:show]

  #Roomは2つのEntryを持ちますので、Entryも2つ作成しています。
  def create
    @room = Room.create
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to "/rooms/#{@room.id}"
  end
  #チャットルームの画面です。
  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private
#相互フォローでないユーザーが直接チャットルームのURLを検索しても、チャットルームに入れないようにするためのメソッドです。
    def reject_non_related
      room = Room.find(params[:id])
      user = room.entries.where.not(user_id: current_user.id).first.user
      unless (current_user.following?(user)) && (user.following?(current_user))
        redirect_to books_path
      end
    end
end
