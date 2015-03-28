@profile @login-required
Feature: View user profile page
  In order to explore a cucumber hook for auto-login
  As a github user
  I want to see the if it works on the github search page

  Scenario: View profile page
    When I am on the profile page
    Then I should see "Personal settings"
      And I should see "Public profile"
