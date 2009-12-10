require 'vendor/gems/environment'

require 'spec/rake/spectask'
require 'cucumber/rake/task'

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
