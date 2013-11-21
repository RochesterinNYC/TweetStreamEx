Feature: Visitors can access site features by creating an account

  Scenario: Guest visits the site for the first time
    Given I am a guest
    And I visit any page on the site
    Then I should be redirected to the signin page
    And I should be prompted to either log in or create an account
