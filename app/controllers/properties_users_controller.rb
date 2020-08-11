class PropertiesUsersController < ApplicationController
  def index
    @properties_users = PropertiesUser.order('created_at desc').paginate(page: params[:page], per_page: 12).includes(:property).includes(:user)
  end
end