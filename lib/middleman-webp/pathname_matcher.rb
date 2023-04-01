module Middleman
  module WebP
    class PathnameMatcher
      include Comparable
      attr_reader :pattern

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

        send match_method, Pathname.new(path)
      end

      # Compares matchers based on their preciness.
      #
      # - One with longest pattern is considered to be more precise
      # - Glob or Regexp patterns are considered more precise than procs.
      def <=>(other)
        is_proc_involed = other.pattern.respond_to?(:call) || @pattern.respond_to?(:call)
        return compare_to_proc(other) if is_proc_involed

        @pattern.to_s.length <=> other.pattern.to_s.length
      end

      def hash
        @pattern.hash
      end

      private

      def match_method
        @match_method ||=
          if @pattern.respond_to? :call
            :matches_proc?
          elsif @pattern.class == Regexp
            :matches_re?
          else
            :matches_glob?
          end
      end

      def matches_glob?(path)
        path.fnmatch?(@pattern)
      end

      def matches_re?(path)
        !@pattern.match(path.to_s).nil?
      end

      def matches_proc?(path)
        @pattern.call(path.to_s)
      end

      def compare_to_proc(other)
        i_am_proc = @pattern.respond_to?(:call)
        other_is_proc = other.pattern.respond_to?(:call)

        if i_am_proc && !other_is_proc
          return -1
        elsif !i_am_proc && other_is_proc
          return 1
        end

        0
      end
    end
  end
end
