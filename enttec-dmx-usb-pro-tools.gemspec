# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'enttec-dmx-usb-pro-tools/version'

Gem::Specification.new do |s|
  s.name        = 'enttec-dmx-usb-pro-tools'
  s.version     = Enttec::VERSION
  #s.platform    = Gem::Platform::RUBY
  s.authors     = ['art+com/dirk luesebrink']
  s.email       = ['dirk.luesebrink@artcom.de']
  s.homepage    = 'http://github.com/crux/enttec-dmx-usb-pro-tools'
  s.summary     = 'shell & server tools for the ENTTEC DMX USB PRO device'
  s.description = %q{ 
    The ENTTEC DMX USB PRO is a cost efficient device to control DMX from the
    convinience of your USB port. The __enttec-dmx-usb-pro-tools__ gem is a
    collection of tools to control the device from the command line. It also
    includes shell scripts to hook up your enttec device with GOM server model.
  }
  s.add_dependency 'serialport'
  s.add_dependency 'nokogiri'
  s.add_dependency 'applix', '>=0.4.4'
  s.add_dependency 'gom-script'

  s.add_development_dependency 'rspec', '~> 2.12.0'
  s.add_development_dependency 'rspec-mocks'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'growl'
  s.add_development_dependency 'rb-fsevent', '~> 0.9.1'
  s.add_development_dependency 'fakeweb'

  if RUBY_PLATFORM.match /java/i
    s.add_development_dependency 'ruby-debug'
  else
    ##RUBY_VERSION.match /1.9.3/ and (raise "no ruby-debug in ruby 1.9.3")
    #s.add_development_dependency 'ruby-debug19'
    #s.add_development_dependency 'ruby-debug-base19'
    s.add_development_dependency 'debugger'
  end

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f| 
    File.basename(f)
  end
  s.require_paths = ["lib"]
end
