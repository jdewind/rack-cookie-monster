require 'spec/rake/spectask'
require 'cucumber/rake/task'

task :default => [:spec, :features]

desc "Executes bundler and grabs necessary dependencies to run tests"
task "setup:contrib" do
  system("gem bundle")
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = "spec/**/*_spec.rb"
  t.spec_opts = ["-f s -c"]
end

def setup_common_cucumber_settings(task)
  task.cucumber_opts = "--require features"
  task.binary = 'bin/cucumber'
end

Cucumber::Rake::Task.new(:features) do |t|    
  setup_common_cucumber_settings(t)
  t.cucumber_opts << "--color --format pretty"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "rack-cookie-monster"
    s.summary = "A rack middleware library that allows cookies to be passed through forms parameters."
    s.description = "A rack middleware library that allows for cookies to be passed through form parameters. Specifically, it merges the specified form parameters into the Cookie header of an http request. It gets around the problem of having a flash application which interacts with a web application that uses cookie based sessions."
    s.email = "dewind@atomicobject.com"
    s.homepage = "http://github.com/dewind/rack-cookie-monster"
    s.authors = ["Justin DeWind"]
    s.executables = []
    s.files =  FileList["lib/**/*.rb", "LICENSE", "Rakefile"]
    s.test_files = FileList["spec/**/*.rb", "features/**/*"]
    s.add_dependency "rack", ">=1.0.0"
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
