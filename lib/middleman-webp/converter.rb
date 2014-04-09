require 'middleman-webp/options'

module Middleman
  module WebP
    class Converter
      SUFFIX_RE = /(jpe?g|png|tiff?|gif)$/i

      def initialize(app, options = {}, builder)
        @app = app
        @options = Middleman::WebP::Options.new(options)
        @builder = builder
      end

      def convert
        @original_size = 0
        @converted_size = 0
        convert_images(image_files) do |src, dst|
          next reject_file(dst) if dst.size >= src.size

          @original_size += src.size
          @converted_size += dst.size
          @builder.say_status :webp, "#{dst.path} "\
          "(#{change_percentage(src.size, dst.size)} smaller)"
        end
        print_summary
      end

      def convert_images(paths, &after_conversion)
        paths.each do |p|
          begin
            dst = destination_path(p)
            exec_convert_tool(p, dst)
            yield File.new(p), File.new(dst)
          rescue
            @builder.say_status :webp, "Converting #{p} failed", :red
          end
        end
      end

      def exec_convert_tool(src, dst)
        system("#{tool_for(src)} #{@options.for(src)} -quiet #{src} -o #{dst}")
      end

      # Internal: Return proper tool command based on file type
      #
      # file - Filename
      def tool_for(file)
        file.to_s =~ /gif$/i ? 'gif2webp' : 'cwebp'
      end

      def reject_file(file)
        @builder.say_status :webp, "#{file.path} skipped", :yellow
        File.unlink(file)
      end

      def print_summary
        savings = @original_size - @converted_size
        @builder.say_status :webp, 'Total conversion savings: '\
        "#{number_to_human_size(savings)} "\
        "(#{change_percentage(@original_size, @converted_size)})", :blue
      end

      # Calculate change percentage of converted file size
      #
      # src - File instance of the source
      # dst - File instance of the destination
      def change_percentage(src_size, dst_size)
        return '0 %' if src_size == 0

        format('%g %%', format('%.2f', 100 - 100.0 * dst_size / src_size))
      end

      def destination_path(src_path)
        dst_name = src_path.basename.to_s.gsub(SUFFIX_RE, 'webp')
        src_path.parent.join(dst_name)
      end

      def image_files
        all = ::Middleman::Util.all_files_under(@app.inst.build_dir)
        all.select { |p| p.to_s =~ SUFFIX_RE }
      end

      def number_to_human_size(n)
        return '0 B' if n == 0

        units = %w(B KiB MiB GiB TiB PiB)
        exponent = (Math.log(n) / Math.log(1024)).to_i
        format("%g #{units[exponent]}",
               format('%.2f', n.to_f / 1024**exponent))
      end
    end
  end
end