class LandsController < PropertiesController

  def index
    set_place
    if current_user.try :admin?
      @properties_counts = NotifGenerator.counts(controller_name)
      if [params[:price1], params[:price2], params[:acre1], params[:acre2], params[:cent1], params[:cent2], params[:place]].any?(&:present?)
        @properties = Land.search(state, price_range, acre_range, session[:coordinates]).order('created_at ASC').paginate(per_page: 12, page: params[:page])
      else
        @properties = Land.where(state: state).order('created_at DESC').paginate(per_page: 12, page: params[:page])
      end
    else
      @properties = Land.search('approved', price_range, acre_range, session[:coordinates]).order('created_at ASC').paginate(per_page: 12, page: params[:page])
    end

    if params[:filtering] || params[:page].present?
      render partial: 'lands/properties', locals: {properties: @properties}, layout: false
    else
      render 'index'
    end
  end

  def set_state
    @property = Land.find(params[:id])
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
    @property = Land.new
    render 'form'
  end

  def create
    @property = Land.new(
      property_params.merge(user_id: current_user.id,
                            state: current_user.admin? ? 'approved' : 'new'
      )
    )
    if @property.save
      flash[:notice] = 'Land Listed'
      redirect_to lands_path
    else
      render 'form'
    end
  end

  def edit
    @property = Land.find(params[:id])
    render 'form'
  end

  def update
    @property = Land.find(params[:id])
    if !current_user.admin? && !@property.user == current_user
      render plain: 'unauthorized'
    end
    @property.update(property_params)
    if @property.valid?
      redirect_to lands_path
    else
      render 'form'
    end
  end

  protected

  def state
    [params[:state], 'approved'].find(&:present?)
  end

  def property_params
    params.require(:land).permit(:lat, :lngt, :img1, :img2, :img3, :img4, :img5, :expected_price, :acre, :cent, :landmark, :visible_caption, :place, :iframe)
  end

  def acre_range
    acre1 = params[:acre1]
    acre2 = params[:acre2]
    cent1 = params[:cent1]
    cent2 = params[:cent2]


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

  STATE_MAP = {
    'sold' => 'sold',
    'arcived' => 'archived',
    'new' => 'new',
    'approved' => 'approved'
  }
end