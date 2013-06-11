# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require 'bundler'
require 'bundler/setup'
require 'buff/shell_out/version'
require 'buff/ruby_engine'

class Default < Thor
  extend Buff::RubyEngine

  unless jruby?
    require 'thor/rake_compat'

    include Thor::RakeCompat
    Bundler::GemHelper.install_tasks

    desc "build", "Build buff-shell_out-#{Buff::ShellOut::VERSION}.gem into the pkg directory"
    def build
      Rake::Task["build"].execute
    end

    desc "install", "Build and install buff-shell_out-#{Buff::ShellOut::VERSION}.gem into system gems"
    def install
      Rake::Task["install"].execute
    end

    desc "release", "Create tag v#{Buff::ShellOut::VERSION} and build and push buff-shell_out-#{Buff::ShellOut::VERSION}.gem to Rubygems"
    def release
      Rake::Task["release"].execute
    end
  end

  class Spec < Thor
    namespace :spec
    default_task :unit

    desc "unit", "run the project's unit tests"
    def unit
      exec "rspec --color --format=documentation spec"
    end
  end
end
