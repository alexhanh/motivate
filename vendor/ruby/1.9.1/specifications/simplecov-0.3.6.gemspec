# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simplecov}
  s.version = "0.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christoph Olszowka"]
  s.date = %q{2010-09-16}
  s.description = %q{Code coverage for Ruby 1.9 with a powerful configuration library and automatic merging of coverage across test suites}
  s.email = %q{christoph at olszowka de}
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = [".document", ".gitignore", "LICENSE", "README.rdoc", "Rakefile", "VERSION", "lib/simplecov.rb", "lib/simplecov/adapters.rb", "lib/simplecov/command_guesser.rb", "lib/simplecov/configuration.rb", "lib/simplecov/filter.rb", "lib/simplecov/formatter.rb", "lib/simplecov/formatter/simple_formatter.rb", "lib/simplecov/merge_helpers.rb", "lib/simplecov/result.rb", "lib/simplecov/result_merger.rb", "lib/simplecov/source_file.rb", "simplecov.gemspec", "test/fixtures/app/controllers/sample_controller.rb", "test/fixtures/app/models/user.rb", "test/fixtures/frameworks/rspec_bad.rb", "test/fixtures/frameworks/rspec_good.rb", "test/fixtures/frameworks/testunit_bad.rb", "test/fixtures/frameworks/testunit_good.rb", "test/fixtures/resultset1.rb", "test/fixtures/resultset2.rb", "test/fixtures/sample.rb", "test/helper.rb", "test/test_command_guesser.rb", "test/test_filters.rb", "test/test_merge_helpers.rb", "test/test_result.rb", "test/test_return_codes.rb", "test/test_source_file.rb", "test/test_source_file_line.rb"]
  s.homepage = %q{http://github.com/colszowka/simplecov}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Code coverage for Ruby 1.9 with a powerful configuration library and automatic merging of coverage across test suites}
  s.test_files = ["test/fixtures/app/controllers/sample_controller.rb", "test/fixtures/app/models/user.rb", "test/fixtures/frameworks/rspec_bad.rb", "test/fixtures/frameworks/rspec_good.rb", "test/fixtures/frameworks/testunit_bad.rb", "test/fixtures/frameworks/testunit_good.rb", "test/fixtures/resultset1.rb", "test/fixtures/resultset2.rb", "test/fixtures/sample.rb", "test/helper.rb", "test/test_command_guesser.rb", "test/test_filters.rb", "test/test_merge_helpers.rb", "test/test_result.rb", "test/test_return_codes.rb", "test/test_source_file.rb", "test/test_source_file_line.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<simplecov-html>, [">= 0.3.7"])
      s.add_development_dependency(%q<shoulda>, ["= 2.10.3"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0.beta.20"])
      s.add_development_dependency(%q<jeweler>, ["= 1.4.0"])
    else
      s.add_dependency(%q<simplecov-html>, [">= 0.3.7"])
      s.add_dependency(%q<shoulda>, ["= 2.10.3"])
      s.add_dependency(%q<rspec>, ["~> 2.0.0.beta.20"])
      s.add_dependency(%q<jeweler>, ["= 1.4.0"])
    end
  else
    s.add_dependency(%q<simplecov-html>, [">= 0.3.7"])
    s.add_dependency(%q<shoulda>, ["= 2.10.3"])
    s.add_dependency(%q<rspec>, ["~> 2.0.0.beta.20"])
    s.add_dependency(%q<jeweler>, ["= 1.4.0"])
  end
end