class PropertiesController < ApplicationController
  after_action :send_mail, only: [:create]
  before_action :find_meta


  def index
    set_place
    if current_user.try :admin?
      @properties_counts = NotifGenerator.counts(controller_name)
      @interests_count = NotifGenerator.interest_counts(controller_name)
      if [params[:price1], params[:price2], params[:place], params[:area1], params[:area2], params[:acre1], params[:acre2], params[:cent1], params[:cent2], session[:coordinates]].any?(&:present?)
        @properties = @klass.search(state: params[:state], price_range: price_range, area_range: area_range, acre_range: acre_range, coordinates: session[:coordinates]).order('created_at ASC').paginate(per_page: 12, page: params[:page])
      else
        @properties = @klass.where(state: params[:state]).order('created_at DESC').paginate(per_page: 12, page: params[:page])
      end
    else
      @properties = @klass.search(state: 'approved', price_range: price_range, area_range: area_range, acre_range: acre_range, coordinates: session[:coordinates]).order('created_at ASC').paginate(per_page: 12, page: params[:page])
    end

    if params[:filtering] || params[:page].present?
      render partial: 'common/properties', locals: {properties: @properties}, layout: false
    else
      render 'common/index'
    end
  end

  def search
    @properties = Property.search_query(params[:q]).paginate(per_page: 12, page: params[:page])
    render 'properties', layout: false
  end

  def suggestions
    query = params[:q]
    sql = Property.search_suggestion(query)
    render json: {
      suggestions: sql.map(&:suggestion)
    }
  end

  def mine
    @properties = Property.where(user_id: current_user.id)
  end

  def us

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
    ).select('users.name, users.contact_number, properties_users.seen, properties_users.id')
    render 'common/show'
  end

  def interest
    @property = Property.find(params[:id])
    unless current_user.present?
      flash[:notice] = 'Please Sign In or Sign Up to show interest on this property'
      session[:after_sign_path] = property_show_page_path(@property)
      redirect_to new_user_session_path and return
    end
    existing_interest =  PropertiesUser.where(property_id: @property.id, user_id: current_user.id).last
    if existing_interest.blank?
      PropertiesUser.create(property_id: @property.id, user_id: current_user.id, seen: false)
    else
      existing_interest.update(seen: false)
    end
    flash[:notice] = 'query placed, we will get back to you soon'
    InterestMailer.with(user: current_user, property: @property).interest_placed.deliver_later
    User.where(admin: true).each {|u| NotificationJob.perform_later('new interest', property_path(@property), u.id)}
    redirect_to root_path
  end

  def interests
    @properties_users = PropertiesUser
      .joins(:property)
      .group('properties.id')
      .select('properties.*, properties.id property_id')
      .order('created_at desc').paginate(page: params[:page], per_page: 12).includes(:user)
      .where(properties: {type: controller_name.singularize.camelize, state: 'approved'})
    render 'common/interests'
  end

  def suggest
    if params[:query].blank?
      render json: {
        suggestions: []
      }
    else
      render json: {
        suggestions: GeocoderValues::PLACES.select{ |place|
          place.starts_with?(params[:query].camelize)
        }
      }
    end
  end

  def set_state
    @property = @klass.find(params[:id])
    if !current_user.admin? && !@property.user == current_user
      render plain: 'unauthorized'
    end

    @property.update state: params.permit(:state)[:state]
    render partial: 'common/property_action', locals: {property: @property}, layout: false
  end



  def new
    unless current_user
      redirect_to new_user_session_path and return
    end
    @property = @klass.new
    render 'form'
  end

  def create
    @property = @klass.new(
      property_params.merge(user_id: current_user.id,
                            state: current_user.admin? ? 'approved' : 'new'
      )
    )
    if @property.save
      flash[:notice] = I18n.t("property_name.#{@klass_underscore}") + ' Listed, We will get back to you soon'
      redirect_to send("#{@klass_underscore.pluralize}_path".to_sym)
    else
      render 'form'
    end
  end

  def edit
    @property = @klass.find(params[:id])
    render 'form'
  end

  def update
    @property = @klass.find(params[:id])
    if !current_user.admin? && !@property.user == current_user
      render plain: 'unauthorized'
    end
    @property.update(property_params)
    if @property.valid?
      redirect_to send("#{@klass_underscore}_path".to_sym, @property)
    else
      render 'form'
    end
  end

  def contact
    render 'contact', layout: false
  end


  protected

  def find_meta
    @klass_underscore = controller_name.singularize
    @klass = @klass_underscore.camelize.constantize
  end

  def property_params
    params.require(@klass_underscore.to_sym).permit(:lat, :lngt, :img1, :img2, :img3, :img4, :img5, :expected_price, :acre, :cent, :landmark, :visible_caption, :place, :district, :iframe, :area, :tags)
  end

  def price_range
    return nil if params[:price1].blank? && params[:price2].blank?
    start = params[:price1].present? ? params[:price1].to_i : 0
    ending = params[:price2].present? ? params[:price2].to_i : 99999999999
    (start..ending)
  end

  def area_range
    return nil if params[:area1].blank? && params[:area2].blank?
    start = params[:area1].present? ? params[:area1].to_i : 0
    ending = params[:area2].present? ? params[:area2].to_i : 99999999
    (start..ending)
  end

  def acre_range
    acre1 = params[:acre1]
    acre2 = params[:acre2]
    cent1 = params[:cent1]
    cent2 = params[:cent2]

    return nil if [acre1, acre2, cent1, cent2].all?(&:blank?)

    if acre1.blank? && acre2.blank? && cent1.blank? && cent2.blank?
      (0..99999999)
    elsif acre1.blank? && acre2.blank? && cent1.blank? && cent2.present?
      (0..cent2.to_i)
    elsif acre1.blank? && acre2.blank? && cent1.present? && cent2.blank?
      (cent1.to_i..99999999)
    elsif acre1.blank? && acre2.blank? && cent1.present? && cent2.present?
      (cent1.to_i..cent2.to_i)
    elsif acre1.blank? && acre2.present? && cent1.blank? && cent2.blank?
      (0..acre2.to_i*100)
    elsif acre1.blank? && acre2.present? && cent1.blank? && cent2.present?
      (0..acre2.to_i*100*cent2.to_i)
    elsif acre1.blank? && acre2.present? && cent1.present? && cent2.blank?
      (cent1.to_i..acre2.to_i*100)
    elsif acre1.blank? && acre2.present? && cent1.present? && cent2.present?
      (cent1.to_i..acre2.to_i*100+cent2.to_i)
    elsif acre1.present? && acre2.blank? && cent1.blank? && cent2.blank?
      (acre1.to_i*100..99999999)
    elsif acre1.present? && acre2.blank? && cent1.blank? && cent2.present?
      (acre1.to_i*100..99999999)
    elsif acre1.present? && acre2.blank? && cent1.present? && cent2.blank?
      (acre1.to_i*100+cent1.to_i..99999999)
    elsif acre1.present? && acre2.blank? && cent1.present? && cent2.present?
      (acre1.to_i*100+cent1.to_i..99999999)
    elsif acre1.present? && acre2.present? && cent1.blank? && cent2.blank?
      (acre1.to_i*100..acre2.to_i*100)
    elsif acre1.present? && acre2.present? && cent1.blank? && cent2.present?
      (acre1.to_i*100..acre2.to_i*100+cent2.to_i)
    elsif acre1.present? && acre2.present? && cent1.present? && cent2.blank?
      (acre1.to_i*100+cent1.to_i..acre2.to_i*100)
    else acre1.present? && acre2.present? && cent1.present? && cent2.present?
      (acre1.to_i*100+cent1.to_i..acre2.to_i*100+cent2.to_i)
    end

    
  end

  def set_place
    if session[:place] == params[:place]
      return
    else
      session[:place] = params[:place]
    end

    if params[:place].present?
      result = GeocoderValues::ALL_PLACES[params[:place].rstrip.camelize]
      if result.present?
        session[:coordinates] = result
      else
        session[:coordinates] = [0.0, 0.0]
      end
    else
      session[:coordinates] = nil
    end
  end

  def send_mail
    if @property.valid?
      PropertyMailer.with(user: current_user, property: @property).new_property.deliver_later
      User.where(admin: true).each {|u| NotificationJob.perform_later('new property', property_path(@property), u.id)}
    end
  end
end