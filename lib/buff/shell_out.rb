require 'tempfile'
require 'buff/ruby_engine'

# A Ruby platform agnostic way of executing shell commands on the local system
module Buff
  module ShellOut
    require_relative 'shell_out/version'
    require_relative 'shell_out/response'

    include Buff::RubyEngine
    extend self

    # Executes the given shell command on the local system
    #
    # @param [String] command
    #   The command to execute
    # @param [Hash] env
    #   A hash of enviroment variables to set during execution
    #
    # @return [ShellOut::Response]
    def shell_out(command, env = {})
      env = process_env_vars(env)
      process_status, out, err = jruby? ? jruby_out(command, env) : mri_out(command, env)
      Response.new(process_status, out, err)
    end

    private

      # @param [String] command
      #   The command to execute
      def mri_out(command, env = {})
        out, err = Tempfile.new('mixin.shell_out.stdout'), Tempfile.new('mixin.shell_out.stderr')

        begin
          pid         = Process.spawn(env, command, out: out.to_i, err: err.to_i)
          pid, status = Process.waitpid2(pid)
          # Check if we're getting back a process status because win32-process 6.x was a fucking MURDERER.
          # https://github.com/djberg96/win32-process/blob/master/lib/win32/process.rb#L494-L519
          exitstatus  = status.is_a?(Process::Status) ? status.exitstatus : status
        rescue Errno::ENOENT => ex
          exitstatus = 127
          out.write("")
          err.write("command not found: #{command}")
        end

        out.close
        err.close

        [ exitstatus, File.read(out), File.read(err) ]
      end

      # @param [String] command
      #   The command to execute
      def jruby_out(command, env = {})
        out, err = StringIO.new, StringIO.new
        $stdout, $stderr = out, err
        system(env, command)

        exitstatus = $?.exitstatus
        out.rewind
        err.rewind

        [ exitstatus, out.read, err.read ]
      ensure
        $stdout, $stderr = STDOUT, STDERR
      end

      # Builds a new hash from the given vars hash. The new hash's keys are all uppercase
      # strings representing environment variables.
      #
      # @param [Hash] vars
      #   A hash of environment variables
      def process_env_vars(vars)
        vars.inject({}) do |acc, (key, val)|
          acc[key.to_s.upcase] = val
          acc
        end
      end
  end
end
