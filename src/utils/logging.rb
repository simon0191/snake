require "logger"

module Utils
  module Logging
    def log
      $__logger__ ||= Log.new
    end

    class Log
      attr_accessor :level, :enabled, :delegate
      
      def initialize
        #byebug
        if ENV['log']
          self.enabled = true
          if ENV['log_file']
            file = File.open(ENV['log_file'], File::WRONLY | File::APPEND)
            file.sync = true
            # To create new (and to remove old) logfile, add File::CREAT like:
            # file = File.open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
            self.delegate = Logger.new(file)
          else
            self.delegate = Logger.new(STDOUT)
          end

          self.delegate.level = Logger::DEBUG
        else
          self.enabled = false
        end
      end

      def info(msg)
        return unless enabled
        delegate.info(msg)
      end

      def error(msg)
        return unless enabled
        delegate.error(msg)
      end

      def debug(msg)
        return unless enabled
        delegate.debug(msg)
      end

      def warn(msg)
        return unless enabled
        delegate.warn(msg)
      end
    end
  end
end
