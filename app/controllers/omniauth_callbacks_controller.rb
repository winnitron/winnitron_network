class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect user
  end

  def facebook
    user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect user
  end

  def twitter
    user = User.from_omniauth(request.env["omniauth.auth"])

    info = request.env["omniauth.auth"]["info"]

    twitter = info["urls"]["Twitter"]
    if twitter && user.links.twitters.where(url: twitter).empty?
      user.links.create link_type: "Twitter", url: twitter
    end

    website = info["urls"]["Website"]
    if website && user.links.websites.empty?
      user.links.create link_type: "Website", url: website
    end

    sign_in_and_redirect user
  end
end
