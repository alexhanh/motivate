# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{remarkable}
  s.version = "4.0.0.alpha4"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ho-Sheng Hsiao", "Carlos Brando", "José Valim"]
  s.date = %q{2010-06-11}
  s.description = %q{Remarkable: a framework for rspec matchers and macros, with support for I18n.}
  s.email = ["hosh@sparkfly.com", "eduardobrando@gmail.com", "jose.valim@gmail.com"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README"]
  s.files = ["CHANGELOG", "LICENSE", "README", "lib/remarkable/core.rb", "lib/remarkable/core/base.rb", "lib/remarkable/core/core_ext/array.rb", "lib/remarkable/core/dsl.rb", "lib/remarkable/core/dsl/assertions.rb", "lib/remarkable/core/dsl/callbacks.rb", "lib/remarkable/core/dsl/optionals.rb", "lib/remarkable/core/i18n.rb", "lib/remarkable/core/macros.rb", "lib/remarkable/core/matchers.rb", "lib/remarkable/core/messages.rb", "lib/remarkable/core/negative.rb", "lib/remarkable/core/rspec.rb", "lib/remarkable/core/version.rb", "locale/en.yml", "remarkable.gemspec"]
  s.homepage = %q{http://github.com/carlosbrando/remarkable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{remarkable}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Remarkable: a framework for rspec matchers and macros, with support for I18n.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, [">= 2.0.0.alpha11"])
    else
      s.add_dependency(%q<rspec>, [">= 2.0.0.alpha11"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.0.0.alpha11"])
  end
end
