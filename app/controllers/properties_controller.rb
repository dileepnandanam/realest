class PropertiesController < ApplicationController
  def index
    if current_user.admin?
      @properties = Property.search(params[:query], price_range, acre_range, cent_range).where(state: params[:state]).paginate(per_page: 12, page: params[:page])
    else
      @properties = Property.search(params[:query], price_range, acre_range, cent_range).where(state: 'approved').paginate(per_page: 12, page: params[:page])
    end
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

  protected

  def property_params
    params.require(:property).permit(:lat, :lngt, :img1, :img2, :img3, :img4, :img5, :expected_price, :acre, :cent, :landmark)
  end

  def price_range
    start = params[:price1].present? ? params[:price1] : 0
    ending = params[:price2].present? ? params[:price2] : 99999999999999
    (start..ending)
  end

  def acre_range
    start = params[:acre1].present? ? params[:acre1] : 0
    ending = params[:acre2].present? ? params[:acre2] : 999999
    (start..ending)
  end

  def cent_range
    start = params[:cent1].present? ? params[:cent1] : 0
    ending = params[:cent2].present? ? params[:cent2] : 999999
    (start..ending)
  end
end