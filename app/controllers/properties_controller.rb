class PropertiesController < ApplicationController
  def show
    @property = Property.find(params[:id])
  end

  def interest
    unless current_user.present?
      flash[:notice] = 'Please Sign In or Sign Up show interest on this property'
      redirect_to root_path and return
    end
    @property = Property.find(params[:id])
    unless @property.users.include?(current_user)
      @property.users << current_user
      PropertiesUser.where(property_id: @property.id, user_id: current_user.id).last.update seen: false
    end
    flash[:notice] = 'query placed, we will get back to you soon'
    InterestMailer.with(user: current_user, property: @property).interest_placed.deliver_later
    redirect_to root_path
  end

  def index
    set_place
    if current_user.try :admin?
      @new_properties = NotifGenerator.new_properties
      if [params[:price1], params[:price2], params[:acre1], params[:acre2], params[:cent1], params[:cent2], params[:place]].any?(&:present?)
        @properties = Property.search(params[:state], price_range, acre_range, session[:coordinates]).order('created_at ASC').paginate(per_page: 12, page: params[:page])
      else
        @properties = Property.where(state: params[:state]).order('created_at DESC').paginate(per_page: 12, page: params[:page])
      end
    else
      @properties = Property.search('approved', price_range, acre_range, session[:coordinates]).order('created_at ASC').paginate(per_page: 12, page: params[:page])
    end

    if params[:filtering]
      render partial: 'properties/properties', locals: {properties: @properties}, layout: false
    else
      render 'index'
    end
  end

  def set_state
    @property = Property.find(params[:id])
    if !current_user.admin? && !@property.user == current_user
      render plain: 'unauthorized'
    end

    @property.update state: params.permit(:state)[:state]
    render partial: 'property_action', locals: {property: @property}, layout: false
  end



  def new
    unless current_user
      redirect_to new_user_session_path and return
    end
    @property = Property.new
    render 'form'
  end

  def create
    @property = Property.new(
      property_params.merge(user_id: current_user.id,
                            state: current_user.admin? ? 'approved' : 'new'
      )
    )
    if @property.save
      flash[:notice] = 'Property Listed'
      redirect_to properties_path
    else
      render 'form'
    end
  end

  def edit
    @property = Property.find(params[:id])
    render 'form'
  end

  def update
    @property = Property.find(params[:id])
    if !current_user.admin? && !@property.user == current_user
      render plain: 'unauthorized'
    end
    @property.update(property_params)
    if @property.valid?
      redirect_to properties_path
    else
      render 'form'
    end
  end

  def suggest
    render json: {
      suggestions: Property::PLACES.select{ |place|
        place.starts_with?(params[:query].camelize)
      }
    }
  end


  def interests
    @properties_users = PropertiesUser.order('created_at desc').paginate(page: params[:page], per_page: 12).includes(:property).includes(:user)
  end

  protected

  def set_place
    if session[:place] == params[:place]
      return
    else
      session[:place] = params[:place]
    end

    if params[:place].present?
      result = Geocoder.search(params[:place].gsub('-', ' '))
      if result.first.present?
        session[:coordinates] = result.first.coordinates
      else
        session[:coordinates] = [0.0, 0.0]
      end
    else
      session[:coordinates] = nil
    end
  end

  def property_params
    params.require(:property).permit(:lat, :lngt, :img1, :img2, :img3, :img4, :img5, :expected_price, :acre, :cent, :landmark, :visible_caption, :place)
  end

  def price_range
    start = params[:price1].present? ? params[:price1].to_i : 0
    ending = params[:price2].present? ? params[:price2].to_i : 99999999999999
    (start..ending)
  end

  def acre_range
    acre1 = params[:acre1].blank? ? 0 : params[:acre1].to_i
    acre2 = params[:acre2].blank? ? 0 : params[:acre2].to_i
    cent1 = params[:cent1].blank? ? 0 : params[:cent1].to_i
    cent2 = params[:cent2].blank? ? 0 : params[:cent2].to_i
    if [acre1, acre2, cent1, cent2].any?{|n| n> 0}
      ((acre1 * 100 + cent1)..(acre2 * 100 + cent2))
    else
      (0..99999999)
    end
  end

  STATE_MAP = {
    'sold' => 'sold',
    'arcived' => 'archived',
    'new' => 'new',
    'approved' => 'approved'
  }
end