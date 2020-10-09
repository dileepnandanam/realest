class PropertiesController < ApplicationController

  def interest
    unless current_user.present?
      flash[:notice] = 'Please Sign In or Sign Up to show interest on this property'
      redirect_to root_path and return
    end
    @property = Property.find(params[:id])

    unless @property.users.include?(current_user)
      PropertiesUser.create(property_id: @property.id, user_id: current_user.id, seen: false)
    end
    flash[:notice] = 'query placed, we will get back to you soon'
    InterestMailer.with(user: current_user, property: @property).interest_placed.deliver_later
    redirect_to root_path
  end

  def interests
    @properties_users = PropertiesUser.joins(controller_name.singularize.to_sym).order('created_at desc').paginate(page: params[:page], per_page: 12).includes(:user)
  end

end