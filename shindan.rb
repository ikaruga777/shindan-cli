

exit if ARGV[0].nil?

# Nokogiriライブラリの読み込み
require 'nokogiri'
require 'mechanize'


# スクレイピング先のURL
url = 'https://shindanmaker.com/167854'

mechanize = Mechanize.new
mechanize.user_agent_alias= "Mac Safari 4"
mechanize.get(url) do |page|
  mypage = page.form_with( name: "enter") do |form|
    form.u = ARGV[0]
  end.submit
  doc = Nokogiri::HTML(mypage.content.toutf8)
  puts doc.xpath('string(//div[@class="result2"])').strip
end
