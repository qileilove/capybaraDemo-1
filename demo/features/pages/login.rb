require 'site_prism'

class Login < SitePrism::Page
  set_url applicationURL("login")
  set_url_matcher /login/

  element :userid_field, "#login_field"
  element :password_field, "#password"
  element :signin_button, "[name='commit']"
end
