class HomesController < ApplicationController
  def show
    @message = Message.new
  end
end