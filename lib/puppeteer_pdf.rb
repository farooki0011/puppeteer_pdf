require "puppeteer_pdf/version"
require 'securerandom'

module PuppeteerPdf
  class Error < StandardError; end

  def self.generate_pdf(url, output_file_path ,opts = {})
      random_string = generate_random_string
      page_height = opts[:height] || 600
      page_width = opts[:width] || 1125
      page_layout = opts[:layout] || 'Landscape'
      print_background = opts[:print_background] || true
      header_text = opts[:header_text] || ''
      footer_text = opts[:footer_text] || ''

      raise "ERROR : height must be Integer" unless page_height.class == Integer
      raise "ERROR : widgth must be Integer" unless page_width.class == Integer
      raise "ERROR : layout must be between ['Landscape']" unless ['Landscape'].include?(page_layout)
      raise "ERROR : print_background must be Boolean" unless [TrueClass, FalseClass].include?(print_background.class)
      raise "ERROR : header_text must be String" unless header_text.class == String
      raise "ERROR : footer_text must be String" unless footer_text.class == String

      need_to_display_headers = (header_text == '' && footer_text == '') == true ? false : true

      raise "INVALID PATH, Hint : (/path/file.pdf)" unless output_file_path.include?('.pdf')
      temp_path = output_file_path.reverse.split('/',2)[1].reverse
      tmp_js_file_name = "#{temp_path}/puppeteer_#{random_string}.js"
      js_code = "const puppeteer = require('puppeteer');
                      (async () => {
                          const browser = await puppeteer.launch();
                          const page = await browser.newPage();
                          await page.setViewport({ width: #{page_height}, height: #{page_width} })
                          await page.goto('#{url}', {waitUntil: 'networkidle2'});
                          await page.pdf({path: '#{output_file_path}', width: '#{page_width}px', height: '#{page_height}px', layout: '#{page_layout}' , printBackground: #{print_background}, displayHeaderFooter: #{need_to_display_headers},
  margin: {top: 10, bottom: 40}, headerTemplate: '<span>#{header_text}</span>' });
                          await browser.close();
                    })();"
      file = File.open(tmp_js_file_name, "w")
      file.puts js_code
      file.close
      system("node #{tmp_js_file_name}") # GENERATE EXPORT
      system("rm -rf #{tmp_js_file_name}")
      puts "############################################################################################################"
      puts "PDF IS GENERATED : #{output_file_path}"
      puts "############################################################################################################"
      output_file_path
  end

  def self.generate_random_string
    SecureRandom.alphanumeric[0..5]
  end
end
