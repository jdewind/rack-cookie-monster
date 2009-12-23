here = File.expand_path(File.dirname(__FILE__))
require File.join(here, "..", "vendor/gems/environment")
require File.join(here, "..", "init")
Bundler.require_env :test

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Spec::Runner.configure do |config|
  config.include(SpecInstanceHelpers)
  config.mock_with :mocha
end
