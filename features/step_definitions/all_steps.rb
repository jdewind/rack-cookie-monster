And %r{I change my browser to "(\w+)"} do |browser|
  $browser = Culerity::RemoteBrowserProxy.new $server, {:browser => browser}
  $browser.extend BrowserExtensions
end