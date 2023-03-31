require "middleman-webp/pathname_matcher"

module Middleman
  module WebP
    class Options
      attr_reader :ignore, :verbose, :append_extension, :allow_skip,
        :run_before_build

      def initialize(options = {})
        @ignore = options[:ignore] || []
        @ignore = [*@ignore].map do |pattern|
          Middleman::WebP::PathnameMatcher.new(pattern)
        end

        @conversion = options[:conversion_options] || {}
        @conversion = @conversion.reduce(Hash.new("")) do |h, (k, v)|
          h[Middleman::WebP::PathnameMatcher.new(k)] = to_args(v)
          h
        end

        @verbose = options[:verbose] || false

        @append_extension = options[:append_extension] || false
        @allow_skip = !(false == options[:allow_skip])
        @run_before_build = options[:run_before_build] || false
      end

      # Internal: Generate command line args for cwebp or gif2webp command
      #
      # Find options defined for given file. Selects all options whose
      # glob pattern matches file path and uses the one with longest
      # glob, because it's assumed to be the most precise one.
      def for(file)
        matching = @conversion.select { |m, _o| m.matches? file }

        return "" if matching.empty?

        matching.max_by { |(pathname_matcher, _oa)| pathname_matcher }[1]
      end

      private

      def to_args(options)
        options.map do |k, v|
          if v == true
            "-#{k}"
          elsif v != false
            "-#{k} #{v}"
          end
        end.join(" ").squeeze(" ")
      end
    end
  end
end
