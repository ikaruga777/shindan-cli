require 'optparse'
require 'mechanize'

class Shindan
  BASE_URL = "https://shindanmaker.com/"
  def initialize(argv)
    @argv = argv
  end

  def parse_options
    opts = OptionParser.new @argv
    options = {:id => "167854", :str => "i"}
    opts.on("-i","--id=id"){|v| options[:id] = v}
    opts.on("--LArc"){|v| options[:id] = "334680"}
    opts.on("-s","--str=string"){|s| options[:str] = s}
    opts.parse(ARGV)
    options
  end

  def shindan (id,input)
    client = Mechanize.new
    client.user_agent_alias= "Mac Safari 4"
    url = BASE_URL + id.to_s

    result_text = ""
    client.get(url) do |page|
      result_page = page.form_with( name: "enter") do |form|
        form.u = input
      end.submit
      
      result_text = result_page.at('div.result2').inner_text.strip
    end
    result_text
  end
  
  def main
    options = parse_options()
    puts shindan(options[:id],options[:str])
  end
end
