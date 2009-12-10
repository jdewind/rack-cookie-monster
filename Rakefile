require 'spec/rake/spectask'
task :default => [:spec, :features]

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
    s.summary = "A rack middleware library that allows cookies to be passed through forms"
    s.description = "A rack middleware library that allows cookies to be passed through forms"
    s.email = "dewind@atomicobject.com"
    s.homepage = "http://github.com/dewind/rack-cookie-monster"
    s.authors = ["Justin DeWind"]
    s.files =  FileList["lib"]
    s.test_files = FileList["spec/**/*.rb"]
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end