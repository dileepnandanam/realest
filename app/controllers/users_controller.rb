class UsersController < ApplicationController

  def switch
    sign_in(:user, User.find(params[:id]))
    redirect_to root_path
  end
end