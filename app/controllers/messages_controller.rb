class MessagesController < ApplicationController
  after_action :mark_seen, only: [:index]

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
    render 'new', layout: false
  end

  protected

  def message_params
    params.require(:message).permit(:contact, :content, :name)
  end

  def mark_seen
    @messages.update_all seen: true
  end
end