module Jekyll
  module MyResponsiveImage
    class Renderer

      def initialize(site, attributes)
        @site = site
        @attributes = attributes
      end

      def render_responsive_image
        config = Config.new(@site).to_h

        image_template = @site.in_source_dir(@attributes['template'] || config['template'])
        partial = File.read(image_template)
        template = Liquid::Template.parse(partial)

        info = {
          registers: { site: @site }
        }

        result = template.render!(@attributes.merge(@site.site_payload), info)

      end
    end
  end
end
