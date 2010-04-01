# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rchart}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nilesh Chaudhari", "Amar Daxini"]
  s.date = %q{2010-04-01}
  s.description = %q{Ruby port of the slick pChart charting library}
  s.email = %q{mail@nilesh.org}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "fonts/GeosansLight.ttf",
     "fonts/MankSans.ttf",
     "fonts/Silkscreen.ttf",
     "fonts/pf_arma_five.ttf",
     "fonts/tahoma.ttf",
     "lib/rchart.rb",
     "rchart.gemspec",
     "test/helper.rb",
     "test/test_rchart.rb"
  ]
  s.homepage = %q{http://github.com/nilesh/rchart}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Ruby port of the slick pChart charting library}
  s.test_files = [
    "test/helper.rb",
     "test/test_rchart.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

