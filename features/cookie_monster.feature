Feature: Eats Cookies

Scenario: Browser with user agent that cookie monster shares with
  Given I go to "/"
  And I fill in "Cookie 1" for the text field named "cookie_1"
  And I fill in "Cookie 2" for the text field named "cookie_2"
  And I fill in "Noncookie" for the text field named "non_cookie"
  When I press "Submit"
  Then I should see "cookies" for
    | name      | value     |
    | cookie_1  | Cookie 1  |
    | cookie_2  | Cookie 2  |
  But I should not see "cookies" for
    | name        | value       |
    | non_cookie  | Noncookie   |
  But I should see "params" for
    | name        | value       |
    | non_cookie  | Noncookie   |
  
Scenario: User agent does not match cookie monster's share list
  Given I change my browser to "ie"
  When I go to "/"
  And I fill in "Cookie 1" for the text field named "cookie_1"
  And I fill in "Cookie 2" for the text field named "cookie_2"
  And I fill in "Noncookie" for the text field named "non_cookie"
  When I press "Submit"
  Then I should not see "cookies" for
    | name      | value     |
    | cookie_1  | Cookie 1  |
    | cookie_2  | Cookie 2  |
  But I should see "params" for
    | name        | value       |
    | non_cookie  | Noncookie   |
    | cookie_1    | Cookie 1    | 
    | cookie_2    | Cookie 2    |

Scenario: Browser that has existing cookies for domain
  Given My browser has the following cookies 
    | name    | value   |
    | session | secrets |
    | creds   | street  |
  When I go to "/"
  And I fill in "Cookie 1" for the text field named "cookie_1"
  And I press "Submit"
  Then I should see "cookies" for
    | name      | value     |
    | cookie_1  | Cookie 1  |
    | session   | secrets   |
    | creds     | street    |
    