require 'jekyll'
require 'jekyll_picture_tag'

require_relative 'jekyll_my_responsive_image/renderer'
require_relative 'jekyll_my_responsive_image/config'
require_relative 'jekyll_my_responsive_image/tag'

Liquid::Template.register_tag('responsive_image', Jekyll::MyResponsiveImage::Tag)

