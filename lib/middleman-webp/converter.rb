require "middleman-webp/options"

module Middleman
  module WebP

    class Converter

      def initialize(app, options={}, builder)
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
          @builder.say_status :webp, "#{dst.path} (#{change_percentage(src.size,dst.size)} smaller)"
        end
        savings = @original_size - @converted_size
        @builder.say_status(:webp, "Total conversion savings: #{number_to_human_size(savings)} (#{change_percentage(@original_size, @converted_size)})", :blue)
      end

      def convert_images(paths, &after_conversion)
        paths.each do |p|
          dst = destination_path(p)
          exec_convert_tool(p, dst)
          yield File.new(p), File.new(dst)
        end
      end

      def exec_convert_tool(src, dst)
        system("#{tool_for(src)} #{@options.for(src)} -quiet #{src} -o #{dst}")
      end

      # Internal: Return proper tool command based on file type
      #
      # file - Filename
      def tool_for(file)
        file.to_s =~ /gif$/i ? "gif2webp" : "cwebp"
      end

      def reject_file(file)
        @builder.say_status :webp, "#{file.path} skipped", :yellow
        File.unlink(file)
      end

      # Calculate change percentage of converted file size
      #
      # src - File instance of the source
      # dst - File instance of the destination
      def change_percentage(src_size, dst_size)
        "%g %%" % ("%.2f" % [100 - 100.0 * dst_size / src_size])
      end

      def destination_path(src_path)
        dst_name = src_path.basename.to_s.gsub(/(jpe?g|png|tiff?|gif)$/, "webp")
        src_path.parent.join(dst_name)
      end

      def image_files
        all = ::Middleman::Util.all_files_under(@app.inst.build_dir)
        all.select {|p| p.to_s =~ /(jpe?g|png|tiff?|gif)$/i }
      end

      def number_to_human_size(n)
        units = %w{B KiB MiB GiB TiB PiB}
        exponent = (Math.log(n) / Math.log(1024)).to_i
        "%g #{units[exponent]}" % ("%.2f" % (n.to_f / 1024**exponent))
      end
    end
  end
end
