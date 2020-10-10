class CarsController < PropertiesController
  
  def index
    set_place
    if current_user.try :admin?
      @properties_counts = NotifGenerator.counts(controller_name)
      if [params[:price1], params[:price2], params[:place]].any?(&:present?)
        @properties = Car.search(params[:state], price_range, params[:model], params[:brand], session[:coordinates]).order('created_at ASC').paginate(per_page: 12, page: params[:page])
      else
        @properties = Car.where(state: params[:state]).order('created_at DESC').paginate(per_page: 12, page: params[:page])
      end
    else
      @properties = Car.search('approved', price_range, params[:model], params[:brand], session[:coordinates]).order('created_at ASC').paginate(per_page: 12, page: params[:page])
    end

    if params[:filtering]
      render partial: 'cars/properties', locals: {properties: @properties}, layout: false
    else
      render 'index'
    end
  end

  def set_state
    @property = Property.find(params[:id])
    if !current_user.admin? && !@property.user == current_user
      render plain: 'unauthorized' and return
    end

    @property.update state: params.permit(:state)[:state]
    render partial: 'property_action', locals: {property: @property}, layout: false
  end



  def new
    unless current_user
      redirect_to new_user_session_path and return
    end
    @property = Car.new
    render 'form'
  end

  def create
    @property = Car.new(
      property_params.merge(user_id: current_user.id,
                            state: current_user.admin? ? 'approved' : 'new'
      )
    )
    if @property.save
      flash[:notice] = 'Car Listed'
      redirect_to cars_path
    else
      render 'form'
    end
  end

  def edit
    @property = Car.find(params[:id])
    render 'form'
  end

  def update
    @property = Car.find(params[:id])
    if !current_user.admin? && !@property.user == current_user
      render plain: 'unauthorized'
    end
    @property.update(property_params)
    if @property.valid?
      redirect_to cars_path
    else
      render 'form'
    end
  end

  def suggest_brand
    render json: {
      suggestions: Car.select('distinct lower(brand) brand').all.map(&:brand).select{ |item_name|
        item_name.starts_with?(params[:query].downcase)
      }
    }
  end

  def suggest_model
    render json: {
      suggestions: Car.select('distinct model').all.map(&:model).select{ |item_name|
        item_name.starts_with?(params[:query])
      }
    }
  end

  protected

  def property_params
    params.require(:car).permit(:lat, :lngt, :img1, :img2, :img3, :img4, :img5, :expected_price, :acre, :cent, :landmark, :visible_caption, :place, :brand, :model, :iframe)
  end

  STATE_MAP = {
    'sold' => 'sold',
    'arcived' => 'archived',
    'new' => 'new',
    'approved' => 'approved'
  }
end