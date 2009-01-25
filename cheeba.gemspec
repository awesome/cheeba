# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cheeba}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["So Awesome Man"]
  s.date = %q{2009-04-20}
  s.default_executable = %q{cheeba}
  s.description = %q{Simple data serialization serialization for only the Ruby Programming Language.}
  s.email = ["callme@1800AWESO.ME"]
  s.executables = ["cheeba"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/cheeba", "cheeba.gemspec", "lib/cheeba.rb", "lib/cheeba/defaults.rb", "lib/cheeba/errors.rb", "lib/cheeba/indicators.rb", "lib/cheeba/reader.rb", "lib/cheeba/reader/builder.rb", "lib/cheeba/reader/format.rb", "lib/cheeba/reader/node.rb", "lib/cheeba/reader/parser.rb", "lib/cheeba/version.rb", "lib/cheeba/writer.rb", "lib/cheeba/writer/builder.rb", "test/files/arrays.cash", "test/files/blank.cash", "test/files/comments.cash", "test/files/hashes.cash", "test/files/malformed.cash", "test/files/mixed.cash", "test/files/split.cash", "test/test_cheeba.rb", "test/test_reader.rb", "test/test_reader_builder.rb", "test/test_reader_format.rb", "test/test_reader_parser.rb", "test/test_writer.rb", "test/test_writer_builder.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://awesomebrandname.com}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cheeba}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple data serialization serialization for only the Ruby Programming Language.}
  s.test_files = ["test/test_cheeba.rb", "test/test_reader.rb", "test/test_reader_builder.rb", "test/test_reader_format.rb", "test/test_reader_parser.rb", "test/test_writer.rb", "test/test_writer_builder.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.2"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.2"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.2"])
  end
end
