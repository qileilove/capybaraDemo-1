Feature: Github Search to explore Capybara
  In order to explore capybara functionality
  As a capybara user
  I want to see the if it works on the github search page

  Scenario: Use search page
    Given I am on the search page
    When I fill in "q" with "zenoss/zep"
      And I click "Search"
    Then I should see "zenoss-zep"
