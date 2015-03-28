@search
Feature: Github Search to explore Capybara
  In order to explore capybara functionality
  As a github user
  I want to see the if it works on the github search page

  Scenario: Use search page
    Given I am on the search page
    When I fill in "q" with "zenoss/zep"
      And I click "Search"
    Then I should see "zenoss-zep"

  #
  # The following is an example of how to mark a test "Pending".
  # The details in the steps for this scenario are not important in this case.
  # What is important is to note the ability to create a scenario that will
  # not be counted as passed or failed, but merely "pending."
  # This allows test scenarios to be defined BEFORE the steps and/or code
  # to support those scenarios are fully implemented.
  #
  Scenario: Use Google search page
    Given PENDING I am on the Google search page
    When I fill in "q" with "cucumber capybara"
      And I click "Google Search"
    Then I should see "jnicklas/capybara"
