class Properties::PropertyAssetsController < ApplicationController
  def new
    @property = Property.find_by_id(params[:property_id])
    if !current_user.admin? && @property.user != current_user
      render 'layouts/noaccess' and return
    end
    @property_asset = PropertyAsset.new
    render 'new', layout: false
  end

  def create
    @property = Property.find_by_id(params[:property_id])
    if !current_user.admin? && @property.user != current_user
      render 'layouts/noaccess' and return
    end

    @property_asset = @property.property_assets.create(property_asset_params)
    if @property_asset.valid?
      render partial: 'property_asset', locals:{property_asset: @property_asset}
    else
      render 'new', layout: false, status: 422 
    end
  end

  def destroy
    @property = Property.find_by_id(params[:property_id])
    if !current_user.admin? && @property.user != current_user
      render 'layouts/noaccess' and return
    end

    @property.property_assets.find_by_id(params[:id]).delete
  end

  protected

  def property_asset_params
    params.require(:property_asset).permit(:iframe, :image)
  end
end