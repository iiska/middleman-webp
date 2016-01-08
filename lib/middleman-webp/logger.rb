module Middleman
  module WebP
    class Logger
      def initialize(builder, opts = {})
        @builder = builder
        @options = opts
      end

      def info(msg, color = nil)
        @builder.thor.say_status :webp, msg, color
      end

      def error(msg)
        info msg, :red
      end

      def warn(msg)
        info msg, :yellow
      end

      def debug(msg)
        info msg if @options[:verbose]
      end
    end
  end
end
