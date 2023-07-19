source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "~> 4"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima"

# Installation issue: Can't install RMagick 4.0.0. Can't find magick/MagickCore.h. #806
# https://github.com/rmagick/rmagick/issues/806 
gem "rmagick"

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed"

  # XMLSitemap for SEO indexing
  gem 'jekyll-sitemap'

  # Adds the following meta tags to your site:
  # Fork of https://github.com/jekyll/jekyll-seo-tag
  # Adds 'article:modified_time' from last_modified_at
  gem 'jekyll-seo-tag', git: 'https://github.com/fl3a/jekyll-seo-tag', branch: 'master'
 
  # jekyll-toc - Table of Contents
  # https://github.com/toshimaru/jekyll-toc
  gem 'jekyll-toc'

  # Pagination & Tags
  # https://jekyllrb.com/docs/pagination/
  gem 'jekyll-paginate-v2'

  # https://github.com/wildlyinaccurate/jekyll-responsive-image
  gem 'jekyll-responsive-image'

  gem 'rouge'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.0" if Gem.win_platform?
