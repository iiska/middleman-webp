require "bundler/gem_tasks"

require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList["spec/spec_helper.rb", "spec/**/*_spec.rb"]
end
