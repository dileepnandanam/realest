class PropertyMailer < ApplicationMailer
  def new_property
    @user = params[:user]
    @property = params[:property]
    mail(to: User.where(admin: true).first.email, subject: 'New property')
  end
end