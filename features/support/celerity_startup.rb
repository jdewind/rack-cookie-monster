require 'culerity'

SERVER_PID = "server.pid"

$port = 9292
$host = "http://localhost:#{$port}"

Before do 
  $browser = Culerity::RemoteBrowserProxy.new $server, {:browser => :firefox}
  module BrowserExtensions; end
  $browser.extend BrowserExtensions
  @host = $host 
  @port = $port
end

def kill_test_server
  if File.exist?(SERVER_PID)
    test_server_pid = File.read(SERVER_PID).to_i
    puts "Killing #{test_server_pid}"
    Process.kill "KILL", test_server_pid
    File.delete SERVER_PID
  end
end

def host_listening_on_port?(host, port, timeout=0)
  start_time = Time.now
  begin
    socket = TCPSocket.open(host, port)
    socket.close
    return true
  rescue Errno::ECONNREFUSED
    if Time.now - start_time < timeout
      # try to connect again
      sleep 0.25
      retry 
    else
      return false
    end
  end
end


if host_listening_on_port? "localhost", $port
  puts "Server already running on test port. Killing it..."
  kill_test_server
end

%x(bin/rackup --require lib/rack_cookie_monster --require vendor/gems/environment --daemon --pid #{SERVER_PID} --server webrick features/monster.ru)
raise "Couldn't start server" unless host_listening_on_port? "localhost", $port, 10

$server ||= Culerity::run_server

at_exit do
  kill_test_server
  $browser.exit
  $server.close
end
