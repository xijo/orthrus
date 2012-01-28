require 'bundler'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

# Rake::TestTask.new do |t|
#   t.libs << 'test'
# end

# desc "Run tests"
# task :default => :test


require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :spec do
  task :start_simplecov do
    ENV['SPEC_COVERAGE'] = '1'
  end

  desc "Run all specs with coverage"
  task simplecov: [ :'spec:start_simplecov', :spec ]

  namespace :simplecov do
    desc "Clean all coverage files"
    task :clean do
      rm_rf 'coverage'
    end

    desc "Run all specs and open the result in browser"
    task view: :'spec:simplecov' do
      sh 'open coverage/index.html'
    end
  end
end
