# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{enttec-dmx-usb-pro-tools}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["dirk luesebrink"]
  s.date = %q{2009-10-22}
  s.default_executable = %q{enttec-dmx-usb-pro}
  s.description = %q{ 
      The ENTTEC DMX USB PRO is a cost efficient device to control DMX from the
      convinience of your USB port. The __enttec-dmx-usb-pro-tools__ gem is a
      collection of tools to control the device from the command line. It also
      includes unix server script to hook up your dmx pro with a [GOM][1] (_not
      yet released_) server model.
    }
  s.email = %q{dirk.luesebrink@gmail.com}
  s.executables = ["enttec-dmx-usb-pro"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "bin/enttec-dmx-usb-pro",
     "doc/DMXUSBPro.pdf",
     "enttec-dmx-usb-pro-tools.gemspec",
     "lib/enttec-dmx-usb-pro-tools.rb",
     "lib/enttec-dmx-usb-pro-tools/rdmx.rb",
     "lib/enttec-dmx-usb-pro-tools/server.rb",
     "spec/dmx_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/crux/enttec-dmx-usb-pro-tools}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{shell & server tools for the ENTTEC DMX USB PRO device}
  s.test_files = [
    "spec/dmx_spec.rb",
     "spec/spec_helper.rb"
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
