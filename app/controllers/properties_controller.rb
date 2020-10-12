class PropertiesController < ApplicationController
  def mine
    @properties = Property.where(user_id: current_user.id)
  end

  def show
    klass = controller_name.singularize.camelize.constantize
    @property = klass.find(params[:id])
    
    if @property.state != 'approved' && !current_user.try(:admin?)
      render 'layouts/noaccess' and return
    end

    @property_users = PropertiesUser
      .joins(:user)
      .where(properties_users:{
        property_id: params[:id]
      }
    ).select('users.name, users.contact_number')
  end

  def interest
    @property = Property.find(params[:id])
    unless current_user.present?
      flash[:notice] = 'Please Sign In or Sign Up to show interest on this property'
      session[:after_sign_path] = property_show_page_path(@property)
      redirect_to new_user_session_path and return
    end
    unless PropertiesUser.where(property_id: @property.id, user_id: current_user.id).last.present?
      PropertiesUser.create(property_id: @property.id, user_id: current_user.id, seen: false)
    end
    flash[:notice] = 'query placed, we will get back to you soon'
    InterestMailer.with(user: current_user, property: @property).interest_placed.deliver_later
    redirect_to root_path
  end

  def interests
    @properties_users = PropertiesUser
      .joins(:property)
      .group('properties.id')
      .select('properties.*, properties.id property_id')
      .order('created_at desc').paginate(page: params[:page], per_page: 12).includes(:user)
      .where(properties: {type: controller_name.singularize.camelize, state: 'approved'})
  end

  def suggest
    render json: {
      suggestions: GeocoderValues::MAP.keys.select{ |place|
        place.starts_with?(params[:query].camelize)
      }
    }
  end


  protected

  def price_range
    start = params[:price1].present? ? params[:price1].to_i : 0
    ending = params[:price2].present? ? params[:price2].to_i : 99999999999
    (start..ending)
  end

  def area_range
    start = params[:area1].present? ? params[:area1].to_i : 0
    ending = params[:area2].present? ? params[:area2].to_i : 99999999
    (start..ending)
  end

  def set_place
    if session[:place] == params[:place]
      return
    else
      session[:place] = params[:place]
    end

    if params[:place].present?
      result = GeocoderValues::MAP[params[:place]]
      if result.first.present?
        session[:coordinates] = result
      else
        session[:coordinates] = [0.0, 0.0]
      end
    else
      session[:coordinates] = nil
    end
  end

  def property_show_page_path(property)
    eval("#{property.type.underscore.singularize}_path(property)")
  end

end