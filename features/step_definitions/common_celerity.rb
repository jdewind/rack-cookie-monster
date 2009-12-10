module BrowserExtensions
  def current_html
    div(:xpath => "/.").html
  end
end

Then %r{^I eval:?(.*)} do |code|
  eval code
end

When %r{^I (am curious|debug)} do |what|
  require 'ruby-debug'
  debugger
end

And "I pass out" do
  sleep
end

Then /I should be redirected to "(.*)"/ do |url|
  $browser.url.should == url 
end

When /I press "(.*)"/ do |button|
  $browser.button(:text, button).click
  assert_successful_response
end

When /I follow "(.*)"/ do |link|
  $browser.link(:text, /#{link}/).click
  assert_successful_response
end

When %r{^I browse to "([^"]+)"$} do |url|
  $browser.goto url
end

When %r{^I refresh$} do 
  $browser.refresh
end

When /I fill in "(.*)" for "(.*)"/ do |value, field|
  $browser.text_field(:id, find_label(field).for).set(value)
end

And %r{^I select file "([^"]*)" for "([^"]*)"$} do |file, field|
  $browser.file_field(:id, find_label(field).for).set(test_file(file))
end

When %r{^I fill in "([^"]*)" for the text field named "([^"]*)"$} do |value, field|
  $browser.text_field(:name, field).set(value)
end

When "I go back" do
  $browser.back
end

When /I check "(.*)"/ do |field|
  $browser.check_box(:id, find_label(field).for).set(true)
end

When /^I uncheck "(.*)"$/ do |field|
  $browser.check_box(:id, find_label(field).for).set(false)
end

When /I select "(.*)" from "(.*)"/ do |value, field|
  $browser.select_list(:id, find_label(field).for).select value
end

When /I select "(.*)" from select field "(.*)"/ do |value, field|
  $browser.select_list(:name => field).select value
end

When /I choose "(.*)"/ do |field|
  $browser.radio(:id, find_label(field).for).set(true)
end

When /I go to "(.+)"/ do |path|
  $browser.goto @host + path
  assert_successful_response
end

When /I wait for the (AJAX|restful).*/ do |what|
  $browser.wait
end

When %r{I wait (\d+) seconds} do |seconds|
  sleep seconds.to_i
end

Then %r{^I should see "([^"]+)"$} do |text|
  $browser.current_html.should match(text)
end

When /I puts/ do ||
  puts $browser.current_html
end

Then %r{^I should not see "([^"]+)"$} do |text|
  $browser.current_html.should_not match(text)
end

Then %r{^I change "([^"]+)" to "([^"]+)"$} do |field, value|
  $browser.text_field(:id, find_label(field).for).set(value)
end

Then %r{^I should see "([^\"]*)" with value "([^\"]*)"$} do |field_selector, value|
  doc = Nokogiri.HTML($browser.current_html)
  node = doc.at("//*[@id = //label[contains(.,'#{field_selector}')]/@for]") 
  node ||= doc.at("##{field_selector}")
  node ||= doc.at("*[@name = '#{field_selector}']")

  case node.name
  when "input"
    node["value"].should include(value)
  when 'textarea'
    node.text.should include(value)
  else
    raise "Bad field type: don't know how to check value of a node of type #{node.name}. You should add support!"
  end
end

Then %r{^I should see the radio buttons with these settings$} do |table|
  table.raw.each do |label, state|
    radio = $browser.radio(:id, find_label(label).for)
    case state
    when "checked"
      radio.should be_checked
    when "unchecked"
      radio.should_not be_checked
    end
  end
end

Then %r{^I should see the "([^"]+)" form$} do |form|
  $browser.current_html.should have_selector("form##{form}_form")
end

When %r{^I browse$} do ||
  page = $browser.current_html
  puts page
end

def find_label(text)
  $browser.label :text, text
end

def assert_successful_response(allow_bad_response=false)
  status = $browser.page.web_response.status_code
  if(status == 302 || status == 301)
    location = $browser.page.web_response.get_response_header_value('Location')
    puts "Being redirected to #{location}"
    $browser.goto location
    assert_successful_response
  elsif status != 200 and !allow_bad_response
    tmpfilename = "#{Rails.root}/tmp/culerity-#{Process.pid}-#{Time.now.to_i}.html"
    File.open(tmpfilename, "w"){|io| io << $browser.html}
    `open -a /Applications/Safari.app #{tmpfilename}`
    raise "Browser returned Response Code #{$browser.page.web_response.status_code}"
  end
end

def fill_in_textfield(field, value)
  $browser.text_field(:id, find_label(field).for).set(value)
end

