require 'rss'

module DashboardHelper

  def read_rss(widget)
    if widget.rss_url
      RSS::Parser.parse(open(widget.rss_url).read, false).items[0..widget.rss_limit.to_i]
    end
  rescue StandardError => error
    puts error.message
  end

end
