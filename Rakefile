require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "enttec-dmx-usb-pro-tools"
    gem.summary = %Q{shell & server tools for the ENTTEC DMX USB PRO device}
    gem.description = %Q{ 
      The ENTTEC DMX USB PRO is a cost efficient device to control DMX from the
      convinience of your USB port. The __enttec-dmx-usb-pro-tools__ gem is a
      collection of tools to control the device from the command line. It also
      includes unix server script to hook up your dmx pro with a [GOM][1] (_not
      yet released_) server model.
    }.gsub /\n\n/, ''
    gem.email = "dirk.luesebrink@gmail.com"
    gem.homepage = "http://github.com/crux/enttec-dmx-usb-pro-tools"
    gem.authors = ["art+com/dirk luesebrink"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-c)
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'spec/**/*_spec.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "enttec-dmx-usb-pro-tools #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :test => :check_dependencies
task :default => :spec
