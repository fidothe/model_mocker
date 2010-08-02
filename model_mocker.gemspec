# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "model_mocker"
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Patterson"]
  s.date = "2010-08-02"
  s.description = %q{Declarative partial mocking for ActiveRecord}
  s.email = "matt@reprocessed.org"
  s.extra_rdoc_files = [
    "MIT-LICENSE",
    "README.rdoc"
  ]
  s.files = Dir.glob([
    "VERSION",
    "README.rdoc",
    "MIT-LICENSE",
    "Rakefile",
    "lib/**/*.rb",
    "rails/**/*.rb"
  ])
  s.homepage = "http://github.com/fidothe/model_mocker"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.6"
  s.summary = %q{Declarative partial mocking for ActiveRecord}
  s.test_files = Dir.glob([
    "spec/spec.opts",
    "spec/**/*.rb",
  ])
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
    
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<activerecord>, [">= 2.3"])
      s.add_dependency(%q<mocha>, [">= 0.9.8"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<activerecord>, [">= 2.3"])
      s.add_dependency(%q<mocha>, [">= 0.9.8"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<activerecord>, [">= 2.3"])
    s.add_dependency(%q<mocha>, [">= 0.9.8"])
  end
end

