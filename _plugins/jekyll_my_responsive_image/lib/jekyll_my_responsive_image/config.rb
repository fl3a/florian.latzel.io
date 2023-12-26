module Jekyll
  module MyResponsiveImage
    class Config
      DEFAULTS = {
      }

      def initialize(site)
        @site = site
      end

      def valid_config(config)
        config.has_key?('my_responsive_image') && config['my_responsive_image'].is_a?(Hash)
      end

      def to_h
        config = {}

        if valid_config(@site.config)
          config = @site.config['my_responsive_image']
        end


        DEFAULTS.merge(config)
                .merge(site_source: @site.source, site_dest: @site.dest)
      end
    end
  end
end
