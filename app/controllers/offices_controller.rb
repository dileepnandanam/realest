class OfficesController < PropertiesController
  def show
    @property = Office.find(params[:id])
  end

  def index
    set_place
    if current_user.try :admin?
      @properties_counts = NotifGenerator.counts(controller_name)
      if [params[:price1], params[:price2], params[:place]].any?(&:present?)
        @properties = Office.search(params[:state], price_range, session[:coordinates]).order('created_at ASC').paginate(per_page: 12, page: params[:page])
      else
        @properties = Office.where(state: params[:state]).order('created_at DESC').paginate(per_page: 12, page: params[:page])
      end
    else
      @properties = Office.search('approved', price_range, session[:coordinates]).order('created_at ASC').paginate(per_page: 12, page: params[:page])
    end

    if params[:filtering]
      render partial: 'lands/properties', locals: {properties: @properties}, layout: false
    else
      render 'index'
    end
  end

  def set_state
    @property = Office.find(params[:id])
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
    @property = Office.new
    render 'form'
  end

  def create
    @property = Office.new(
      property_params.merge(user_id: current_user.id,
                            state: current_user.admin? ? 'approved' : 'new'
      )
    )
    if @property.save
      flash[:notice] = 'Office Listed'
      redirect_to offices_path
    else
      render 'form'
    end
  end

  def edit
    @property = Office.find(params[:id])
    render 'form'
  end

  def update
    @property = Office.find(params[:id])
    if !current_user.admin? && !@property.user == current_user
      render plain: 'unauthorized'
    end
    @property.update(property_params)
    if @property.valid?
      redirect_to offices_path
    else
      render 'form'
    end
  end


  protected

  def property_params
    params.require(:office).permit(:lat, :lngt, :img1, :img2, :img3, :img4, :img5, :expected_price, :acre, :cent, :landmark, :visible_caption, :place, :iframe, :area)
  end

  STATE_MAP = {
    'sold' => 'sold',
    'arcived' => 'archived',
    'new' => 'new',
    'approved' => 'approved'
  }
end