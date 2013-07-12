# Buff::ShellOut
[![Gem Version](https://badge.fury.io/rb/buff-shell_out.png)](http://badge.fury.io/rb/buff-shell_out)
[![Build Status](https://travis-ci.org/RiotGames/buff-shell_out.png?branch=master)](https://travis-ci.org/RiotGames/buff-shell_out)

Buff up your code with a mixin for issuing shell commands and collecting the output

## Installation

Add this line to your application's Gemfile:

    gem 'buff-shell_out'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install buff-shell_out

## Usage

Using it as a mixin

    require 'buff/shell_out'

    class PowerUp
      include Buff::ShellOut
    end

    power_up = PowerUp.new
    power_up.shell_out("ls") #=> <#Buff::ShellOut::Response @exitstatus=0, @stdout="...", @stderr="...">

Using it as a module

    require 'buff/shell_out'

    Buff::ShellOut.shell_out("ls") #=> <#Buff::ShellOut::Response @exitstatus=0, @stdout="...", @stderr="...">

# Authors and Contributors

* Jamie Winsor (<jamie@vialstudios.com>)

Thank you to all of our [Contributors](https://github.com/RiotGames/buff-shell_out/graphs/contributors), testers, and users.
