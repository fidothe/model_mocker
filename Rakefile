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
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'ModelMocker'
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :doc => [:rdoc, 'doc:build']

namespace :doc do
  def make_html_doc(markdown_fragment)
    builder = ::Builder::XmlMarkup.new
    html = builder.html do |html| 
      html.head do |head|
        head.title('')
        head.link(:rel => 'stylesheet', :href => './doc.css')
      end
      html.body do |body|
        body << markdown_fragment
      end
    end
    builder.target!
  end
  
  task :build => 'doc/README.html'
  
  task 'doc/README.html' => 'README.markdown' do 
    require 'rdiscount'
    require 'builder'
    require 'hpricot'
    # process with markdown gem
    html_fragment = RDiscount.new(File.read('README.markdown')).to_html
    # wrap in html body
    html_doc_string = make_html_doc(html_fragment)
    # make first H1 into title
    html_doc = Hpricot.parse(html_doc_string)
    title = html_doc.at('html > body > h1').inner_text
    html_doc.at('html > head > title').inner_html = title
    # write
    File.open('doc/README.html', 'w') { |f| f.write(html_doc.to_html) }
  end
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