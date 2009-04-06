require 'rake'
require 'rake/rdoctask'
rspec_base = File.expand_path(File.dirname(__FILE__) + '/../rspec/lib')
$LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base)
require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc 'Generate documentation for the model_mocker plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.title    = 'ModelMocker'
  rdoc.options << '--line-numbers' << '--inline-source' #<< '--main' << 'ModelMocker'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :stats => "spec:statsetup"

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

namespace :spec do
  desc "Run all specs in spec directory with RCov"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_opts = ['--options', "spec/spec.opts"]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = lambda do
      IO.readlines("spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
    end
  end
  
  desc "Print Specdoc for all specs (excluding plugin specs)"
  Spec::Rake::SpecTask.new(:doc) do |t|
    t.spec_opts = ["--format", "specdoc", "--dry-run"]
    t.spec_files = FileList['spec/**/*_spec.rb']
  end
  
  # Setup specs for stats
  task :statsetup do
    require 'code_statistics'
    ::STATS_DIRECTORIES << %w(All\ specs spec)
    ::CodeStatistics::TEST_TYPES << "All specs"
    ::STATS_DIRECTORIES.delete_if {|a| a[0] =~ /test/}
  end
end