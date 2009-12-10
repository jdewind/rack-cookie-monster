And %r{I change my browser to "(\w+)"} do |browser|
  $browser.clear_cookies
  $browser = Culerity::RemoteBrowserProxy.new $server, {:browser => "ie"}
  $browser.extend BrowserExtensions
end