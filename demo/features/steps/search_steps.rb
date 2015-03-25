
Given(/^I am on the search page$/) do
  visit applicationURL("search")
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |element, text|
  fill_in element, with: text
end

When /^I click "([^"]*)"$/ do |text|
  click_on(text)
end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_content text
end
