require File.expand_path('../../../config/boot',  __FILE__)
require 'nokogiri'
require 'open-uri'
require 'active_record'
require 'require_all'
require_all File.expand_path('../../../app/models',  __FILE__)

page = Nokogiri::HTML(open('http://www.interbrand.com/en/best-global-brands/2013/top-100-list-view.aspx'))

(page.css('tr.rgRow') + page.css('tr.rgAltRow')).each do |row|
  rank_2013 = row.at_xpath("td[1]").content.strip.to_s
  rank_2012 = row.at_xpath("td[2]").content.strip.to_s
  name = row.at_xpath("td[4]").content.strip.to_s
  country = row.at_xpath("td[5]").content.strip.to_s
  sector = row.at_xpath("td[6]").content.strip.to_s
  Brand.find_or_create_by(
    name: name, 
    interbrand_rank_2013: rank_2013,
    interbrand_rank_2012: rank_2012,
    interbrand_country: country,
    interbrand_sector: sector
  )
end