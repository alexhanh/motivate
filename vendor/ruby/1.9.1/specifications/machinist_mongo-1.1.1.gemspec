# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{machinist_mongo}
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nicolas Mérouze", "Cyril Mougel"]
  s.date = %q{2010-07-09}
  s.email = %q{nicolas.merouze@gmail.com}
  s.extra_rdoc_files = ["LICENSE", "README.textile"]
  s.files = [".gitignore", "LICENSE", "README.textile", "Rakefile", "VERSION", "lib/machinist/mongo_mapper.rb", "lib/machinist/mongoid.rb", "machinist_mongo.gemspec", "spec/mongo_mapper_spec.rb", "spec/mongoid_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/nmerouze/machinist_mongo}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Machinist adapters for MongoDB ORMs}
  s.test_files = ["spec/mongo_mapper_spec.rb", "spec/mongoid_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<machinist>, ["~> 1.0.4"])
    else
      s.add_dependency(%q<machinist>, ["~> 1.0.4"])
    end
  else
    s.add_dependency(%q<machinist>, ["~> 1.0.4"])
  end
end
