When(/^I am on the login page$/) do
    visit applicationURL("login")
end

When(/^I fill in the user id field with "(.*?)"$/) do |userid|
   	find("#login_field").set(userid)
end

When(/^I fill in the user id field with the default user id$/) do
    find("#login_field").set(applicationUserID())
end

When(/^I fill in the password field with "(.*?)"$/) do |password|
    find("#password").set(password)
end

When(/^I fill in the password field with the default password$/) do
    find("#password").set(applicationPassword())
end

#
# This is a bit of an anti-pattern because creating highly specific steps for each page
#    when a generic step will suffice creates lots of extra steps, leading to more
#    maintenance overhead. However, in this case the github login page has 2 buttons
#    labeled "Sign in" without ids, so it was impossible to use the more generic
#    when-I-click step.
#
When /^I click the sign-in button$/ do
  find(:css, "[name='commit']").click
end
