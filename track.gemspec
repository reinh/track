Gem::Specification.new do |s|
  s.name = %q{track}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rein Henrichs"]
  s.autorequire = %q{track}
  s.date = %q{2008-11-11}
  s.default_executable = %q{track}
  s.description = %q{A gem that provides an awesome command line interface for time tracking that is awesome.}
  s.email = %q{reinh@reinh.com}
  s.executables = ["track"]
  s.extra_rdoc_files = ["README.rdoc", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README.rdoc", "Rakefile", "TODO", "bin/track", "lib/track.rb", "spec/fixtures", "spec/spec_helper.rb", "spec/track_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/ReinH/track}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A gem that provides an awesome command line interface for time tracking that is awesome.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
