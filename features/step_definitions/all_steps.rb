And %r{I change my browser to "(\w+)"} do |browser|
  $browser = Culerity::RemoteBrowserProxy.new $server, {:browser => browser}
  $browser.extend BrowserExtensions
end

And %r{^I should( not)? see "([^"]+)" for$} do |not_see, container_id, table|
  table.hashes.each do |h|
    container = $browser.div(:id, container_id)
    if not_see
      lambda { 
        container.p(:text, "#{h['name']} - #{h['value']}").text 
      }.should raise_error(/unable to locate/i)
    else
      container.p(:text, "#{h['name']} - #{h['value']}").text.should_not be_nil
    end
  end
end

Given "My browser has the following cookies" do |table|
  table.hashes.each do |h|
    $browser.add_cookie("localhost", h["name"], h["value"])
  end
end