class InterestMailer < ApplicationMailer
  def interest_placed
    @user = params[:user]
    @property = params[:property]
    mail(to: User.where(admin: true).first.email, subject: 'New Interest')
  end
end