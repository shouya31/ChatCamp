class MessagesController < ApplicationController
  before_action :set_room
  before_action :redirect_to_root_path

  def index
    @message = Message.new
    @messages = @room.messages.includes(:user)
  end

  def create
    @message = @room.messages.new(message_params)
    if @message.save
      redirect_to room_messages_path(@room), notice: 'メッセージが送信されました'
    else
      @messages = @room.messages.includes(:user)
      flash.now[:alert] = 'メッセージを入力してください。'
      render :index
    end
  end


  private

  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def redirect_to_root_path
    redirect_to root_path unless @room.users.include?(current_user)
  end
end
