# ENTTEX DMX USB PRO Tools

The ENTTEC DMX USB PRO is a cost efficient device to control DMX from the
convinience of your USB port. The __enttec-dmx-usb-pro-tools__ gem is a
collection of tools to control the device from the command line. It also
includes unix server script to hook up your dmx pro with a [GOM][1] (_not yet
released_) server model.

## Install
    
use the jewler tasks:

    $ rake gemspec build install

## Dependencies 

For the debian system i did the last install the following packages and gems
had to installed:

    $ apt-get install git-core
    $ apt-get install irb
    $ apt-get install telnet
    $ gem install irb
    $ gem install mongrel
    $ gem install nokogiri
    $ gem install open-uri
    $ gem install rack
    $ gem install ruby-debug
    $ gem install ruby-prof
    $ gem install ruby-serialport

## credits

The USB com code got lifted from [Ian Smith-Heisters' Rdmx package][2] which
does includes much more DMX functionallity like animations and fixtures which
i did't need.

[1]: http://github.com/crux/gom
[2]: http://github.com/heisters/rdmx/blob/master/lib/dmx.rb

## Note on Patches/Pull Requests
 
 * Fork the project.
 * Make your feature addition or bug fix.
 * Add tests for it. This is important so I don't break it in a
   future version unintentionally.
 * Commit, do not mess with rakefile, version, or history.
   (if you want to have your own version, that is fine but
    bump version in a commit by itself I can ignore when I pull)
 * Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009 art+com AG/dirk luesebrink. See LICENSE for details.
