# frozen_string_literal: true

require 'optparse'
require 'mechanize'

class Shindan
  BASE_URL = 'https://shindanmaker.com/'
  def initialize(argv)
    @argv = argv
  end

  def parse_options
    opts = OptionParser.new @argv
    options = { id: '167854', str: 'i' }
    opts.on('-i', '--id=id') { |v| options[:id] = v }
    opts.on('--LArc') { |_v| options[:id] = '334680' }
    opts.on('-s', '--str=string') { |s| options[:str] = s }
    opts.parse(ARGV)
    options
  end

  def shindan(id, input)
    raise '255文字以内で入力してください' if input.length > 255
    raise '数値を入れてください' if id !~ /\A[0-9]+\z/

    client = Mechanize.new
    url = BASE_URL + id.to_s
    result_text = ''

    client.get(url) do |page|
      result_page = page.form_with(name: 'enter') do |form|
        raise '診断ページが見つかりません。IDはあってますか?' unless form

        form.u = input
      end.submit

      result = result_page.at('div.result2')
      raise '診断ページが見つかりません。IDはあってますか?' if result

      result_text = result.inner_text.strip
    end
    result_text
  end

  def main
    options = parse_options
    puts shindan(options[:id], options[:str])
  rescue StandardError => e
    puts e
  end
end
