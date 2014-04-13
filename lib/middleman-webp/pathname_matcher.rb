module Middleman
  module WebP
    class PathnameMatcher
      # Initializes matcher with given pattern.
      #
      # pattern - Pattern to match pathnames against to. May be
      #           string, glob, prog or regex.
      def initialize(pattern = '**/*')
        @pattern = pattern
      end

      # Checks given file against pattern.
      #
      # file - File, Pathname or String
      def matches?(path)
        return false if path.nil?

        send match_method, path
      end

      private

      def match_method
        @match_method ||=
          if @pattern.class == Regexp
            :matches_re?
          else
            :matches_glob?
          end
      end

      def matches_glob?(path)
        Pathname.new(path).fnmatch?(@pattern)
      end

      def matches_re?(path)
        !@pattern.match(Pathname.new(path).to_s).nil?
      end
    end
  end
end
