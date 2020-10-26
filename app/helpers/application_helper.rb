module ApplicationHelper

  def thumb_url_for(img1)
    if Rails.env.production?
      img1.service_url
    else
      url_for(img1)
    end
  end
end
