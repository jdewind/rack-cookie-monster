Feature: Eats Cookies

Scenario: Processed form elements and injects them into http cookies
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
  
Scenario: Browser is not firefox
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
    