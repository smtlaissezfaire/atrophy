require "rubygems"
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require "spec/rake/spectask"

desc 'Default: run unit tests (with rspec).'
task :default => :spec

namespace :spec do
  desc "Run all specs with RCov"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec']
  end
end

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the atrophy plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Atrophy'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
