class Properties::PropertiesUsersController < ApplicationController
  def seen
    interest = PropertiesUser.find(params[:id])
    if current_user.admin?
      interest.update seen: true
    end
  end

  def unseen
    interest = PropertiesUser.find(params[:id])
    if current_user.admin?
      interest.update seen: false
    end
  end
end