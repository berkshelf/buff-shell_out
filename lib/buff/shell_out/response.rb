module Buff
  module ShellOut
    class Response
      # @return [Fixnum]
      attr_reader :exitstatus
      # @return [String]
      attr_reader :stdout
      # @return [String]
      attr_reader :stderr

      # @param [Fixnum] exitstatus
      # @param [String] stdout
      # @param [String] stderr
      def initialize(exitstatus, stdout, stderr)
        @exitstatus = exitstatus
        @stdout     = stdout
        @stderr     = stderr
      end

      def success?
        exitstatus == 0
      end

      def error?
        !success?
      end
      alias_method :failure?, :error?
    end
  end
end
