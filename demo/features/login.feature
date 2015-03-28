@login
Feature: User login
  In order to explore capybara functionality
  As a github user
  I want to see the if it login works

  Scenario: Successful login
    When I am on the login page
      And I fill in the user id field with the default user id
      And I fill in the password field with the default password
      And I click the sign-in button
    Then I should see "News Feed"
      And I should see "Pull Requests"
      And I should see "GitHub Bootcamp"

  Scenario: Unsuccessful login
    When I am on the login page
      And I fill in the user id field with "bogus"
      And I fill in the password field with "notarealpassword"
      And I click the sign-in button
    Then I should see "Incorrect username or password."
