source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "~>4.3.2"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima", "~>2.5.1"

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed", "~>0.17.0"

  # XMLSitemap for SEO indexing
  gem "jekyll-sitemap", "~>1.4.0"

  # Adds the following meta tags to your site:
  # Fork of https://github.com/jekyll/jekyll-seo-tag
  # Adds 'article:modified_time' from last_modified_at
  gem "jekyll-seo-tag", "~>2.8.0" , git: 'https://github.com/fl3a/jekyll-seo-tag', branch: 'master'
 
  # Pagination & Tags
  # https://jekyllrb.com/docs/pagination/
  gem "jekyll-paginate-v2", "~>3.0.0"

  # https://github.com/wildlyinaccurate/jekyll-responsive-image
  
  # https://github.com/rbuchberger/jekyll_picture_tag
  gem 'jekyll_picture_tag', '~> 2.0.4'

  # Syntax highlightning
  # https://github.com/rouge-ruby/rouge
  gem "rouge", "~>4.1.2" 
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.0" if Gem.win_platform?

# 1.16.3 and 1.17.0 works, above (>=1.17.1) breaks
gem "ffi", "~> 1.16.3"
