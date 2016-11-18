require 'optparse'
require 'nokogiri'
require 'mechanize'

def shindan (id,input)
  mechanize = Mechanize.new
  mechanize.user_agent_alias= "Mac Safari 4"
  url = "https://shindanmaker.com/#{id}"

  mechanize.get(url) do |page|
    mypage = page.form_with( name: "enter") do |form|
      form.u = input
    end.submit
    doc = Nokogiri::HTML(mypage.content.toutf8)
    return doc.xpath('string(//div[@class="result2"])').strip
  end
end

opts = OptionParser.new
options = {:id => "167854", :str => "i"}
opts.on("-i","--id=id"){|v| options[:id] = v}
opts.on("--LArc"){|v| options[:id] = "334680"}
opts.on("-s","--str=string"){|s| options[:str] = s}
opts.parse(ARGV)
puts shindan(options[:id],options[:str])
