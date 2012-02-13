require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :spec do
  task :start_simplecov do
    ENV['SPEC_COVERAGE'] = '1'
  end

  desc "Run all specs with coverage"
  task :simplecov => [ :'spec:start_simplecov', :spec ]

  namespace :simplecov do
    desc "Clean all coverage files"
    task :clean do
      rm_rf 'coverage'
    end

    desc "Run all specs and open the result in browser"
    task :view => :'spec:simplecov' do
      system 'open coverage/index.html'
    end
  end
end
