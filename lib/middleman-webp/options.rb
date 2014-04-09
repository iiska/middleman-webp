module Middleman
  module WebP
    class Options
      def initialize(options = {})
        @options = options.reduce(Hash.new('')) do |h, (k, v)|
          h[k] = to_args(v)
          h
        end
      end

      # Internal: Generate command line args for cwebp or gif2webp command
      #
      # Find options defined for given file. Selects all options whose
      # glob pattern matches file path and uses the one with longest
      # glob, because it's assumed to be the most precise one.
      def for(file)
        matching = @options.select { |g, o| file.fnmatch?(g) }

        return '' if matching.empty?

        matching.sort { |(ga, oa), (gb, ob)| gb.size <=> ga.size }[0][1]
      end

      private

      def to_args(options)
        options.map do |k, v|
          if v == true
            "-#{k}"
          elsif v != false
            "-#{k} #{v}"
          end
        end.join(' ').gsub(/ +/, ' ')
      end
    end
  end
end
