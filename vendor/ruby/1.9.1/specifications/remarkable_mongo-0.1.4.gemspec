# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{remarkable_mongo}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nicolas Mérouze"]
  s.date = %q{2010-08-20}
  s.email = %q{nicolas.merouze@gmail.com}
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = [".gitignore", "LICENSE", "README.md", "Rakefile", "VERSION", "lib/remarkable/mongo_mapper.rb", "lib/remarkable/mongo_mapper/base.rb", "lib/remarkable/mongo_mapper/describe.rb", "lib/remarkable/mongo_mapper/human_names.rb", "lib/remarkable/mongo_mapper/matchers/allow_values_for_matcher.rb", "lib/remarkable/mongo_mapper/matchers/association_matcher.rb", "lib/remarkable/mongo_mapper/matchers/have_key_matcher.rb", "lib/remarkable/mongo_mapper/matchers/validate_confirmation_of_matcher.rb", "lib/remarkable/mongo_mapper/matchers/validate_length_of_matcher.rb", "lib/remarkable/mongo_mapper/matchers/validate_presence_of_matcher.rb", "locales/en.yml", "remarkable_mongo.gemspec", "spec/matchers/allow_values_for_matcher_spec.rb", "spec/matchers/association_matcher_spec.rb", "spec/matchers/have_key_matcher_spec.rb", "spec/matchers/validate_confirmation_of_matcher_spec.rb", "spec/matchers/validate_length_of_matcher_spec.rb", "spec/matchers/validate_presence_of_matcher_spec.rb", "spec/model_builder.rb", "spec/models.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/nmerouze/remarkable_mongo}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Remarkable Matchers for MongoDB ORMs}
  s.test_files = ["spec/matchers/allow_values_for_matcher_spec.rb", "spec/matchers/association_matcher_spec.rb", "spec/matchers/have_key_matcher_spec.rb", "spec/matchers/validate_confirmation_of_matcher_spec.rb", "spec/matchers/validate_length_of_matcher_spec.rb", "spec/matchers/validate_presence_of_matcher_spec.rb", "spec/model_builder.rb", "spec/models.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<remarkable>, [">= 0"])
      s.add_runtime_dependency(%q<mongo_mapper>, [">= 0.7.6"])
    else
      s.add_dependency(%q<remarkable>, [">= 0"])
      s.add_dependency(%q<mongo_mapper>, [">= 0.7.6"])
    end
  else
    s.add_dependency(%q<remarkable>, [">= 0"])
    s.add_dependency(%q<mongo_mapper>, [">= 0.7.6"])
  end
end
