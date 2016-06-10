require 'middleman-webp/options'

module Middleman
  module WebP
    ##
    # Handles finding image assets and running them through the conversion using
    # external cwebp and gif2webp commandline tools
    class Converter
      SUFFIX_RE = /(jpe?g|png|tiff?|gif)$/i

      def initialize(app, builder, options = {})
        @app = app
        @options = Middleman::WebP::Options.new(options)
        @builder = builder
      end

      def convert
        @original_size = 0
        @converted_size = 0

        convert_images(image_files) do |src, dst|
          next reject_file(dst) if @options.allow_skip && dst.size >= src.size

          @original_size += src.size
          @converted_size += dst.size
          @builder.trigger :created, "#{dst.path} "\
            "(#{change_percentage(src.size, dst.size)} smaller)"
        end
        print_summary
      end

      def convert_images(paths, &_after_conversion)
        paths.each do |p|
          begin
            dst = destination_path(p)
            exec_convert_tool(p, dst)
            yield File.new(p), File.new(dst.to_s)
          rescue StandardError => e
            @builder.trigger :error, "Converting #{p} failed", e.backtrace
          end
        end
      end

      def exec_convert_tool(src, dst)
        cmd = "#{tool_for(src)} #{@options.for(src)} -quiet #{src} -o #{dst}"
        @builder.thor.run(cmd, verbose: @options.verbose, capture: true)
      end

      # Internal: Return proper tool command based on file type
      #
      # file - Filename
      def tool_for(file)
        file.to_s =~ /gif$/i ? 'gif2webp' : 'cwebp'
      end

      def reject_file(file)
        @builder.trigger :deleted, "#{file.path} skipped"
        File.unlink(file)
      end

      def print_summary
        savings = @original_size - @converted_size
        @builder.trigger :webp, '', 'Total conversion savings: '\
          "#{number_to_human_size(savings)} "\
          "(#{change_percentage(@original_size, @converted_size)})"
      end

      # Calculate change percentage of converted file size
      #
      # src - File instance of the source
      # dst - File instance of the destination
      #
      # Examples
      #
      #   change_percentage(100, 75)
      #   # => '25 %'
      #
      # Returns percentage as string.
      def change_percentage(src_size, dst_size)
        return '0 %' if src_size == 0

        format('%g %%', format('%.2f', 100 - 100.0 * dst_size / src_size))
      end

      def destination_path(src_path)
        dst_name = if @options.append_extension
                     "#{src_path.basename}.webp"
                   else
                     src_path.basename.to_s.gsub(SUFFIX_RE, 'webp')
                   end
        src_path.parent.join(dst_name)
      end

      def image_files
        all = ::Middleman::Util.all_files_under(site_dir)
        images = all.select { |p| p.to_s =~ SUFFIX_RE }

        # Reject files matching possible ignore patterns
        @options.ignore.reduce(images) do |arr, matcher|
          arr.select { |path| !matcher.matches? path }
        end
      end

      # Output file size using most human friendly multiple of byte
      # eg. MiB.
      #
      # n - size in bytes
      #
      # Examples
      #
      #   number_to_human_size(12345)
      #   # => '12.06 KiB'
      #
      # Returns string containing size and unit.
      def number_to_human_size(n)
        return '0 B' if n == 0

        units = %w(B KiB MiB GiB TiB PiB)
        exponent = (Math.log(n) / Math.log(1024)).to_i
        format("%g #{units[exponent]}",
               format('%.2f', n.to_f / 1024**exponent))
      end

      private

      def site_dir
        if @options.run_before_build
          Pathname(File.join(@app.root, @app.config[:source]))
        else
          Pathname(@app.config[:build_dir])
        end
      end
    end
  end
end
