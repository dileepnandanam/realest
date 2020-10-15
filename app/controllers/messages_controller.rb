class MessagesController < ApplicationController
  def create
    @message = Message.create message_params
    if @message.valid?
      render 'success', layout: false
    else
      render 'new', status: 422, layout: false
    end
  end

  def index
    @messages = Message.order('created_at DESC')
  end

  def new
    @message = Message.new
  end

  protected

  def message_params
    params.require(:message).permit(:contact, :content, :name)
  end
end