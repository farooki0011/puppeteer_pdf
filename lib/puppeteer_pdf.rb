require "puppeteer_pdf/version"
require 'securerandom'

module PuppeteerPdf
  class Error < StandardError; end

  def self.color_coding(text, color = 'red')
      case color
      when 'red'
          puts "\e[31m#{text}\e[0m"
      when 'green'
          "\e[32m#{text}\e[0m"
      when 'blue'
          "\e[34m#{text}\e[0m"
      end
  end

  def self.generate_pdf(url, output_file_path ,opts = {})
      include_page_numbers  =  opts[:include_page_numbers] || true
      random_string         = generate_random_string
      page_height           = opts[:height] || 600
      page_width            = opts[:width] || 1125
      page_layout           = opts[:layout] || 'Landscape'
      print_background      = opts[:print_background] || true
      header_text           = opts[:header_text] || ''
      footer_text           = opts[:footer_text] || ''
      format                = opts[:format] || 'A4'
      timeout               = opts[:timeout] || 0

      color_coding("ERROR : height must be Integer", 'red') unless page_height.class == Integer
      color_coding("ERROR : widgth must be Integer", 'red') unless page_width.class == Integer
      color_coding("ERROR : layout must be between ['Landscape']", 'red') unless ['Landscape'].include?(page_layout)
      color_coding("ERROR : print_background must be Boolean", 'red') unless [TrueClass, FalseClass].include?(print_background.class)
      color_coding("ERROR : header_text must be String", 'red') unless header_text.class == String
      color_coding("ERROR : footer_text must be String", 'red') unless footer_text.class == String
      color_coding("ERROR : timeout must be Integer", 'red') unless timeout.class == Integer
      color_coding("ERROR : format must be between ['A4']", 'red') unless ['A4'].include?(format)
      color_coding("ERROR : include_page_numbers must be Boolean", 'red') unless [TrueClass, FalseClass].include?(include_page_numbers.class)


      need_to_display_headers = (header_text == '' && footer_text == '') == true ? false : true

      raise "INVALID PATH, Hint : (/path/file.pdf)" unless output_file_path.include?('.pdf')
      temp_path = output_file_path.reverse.split('/',2)[1].reverse
      tmp_js_file_name = "#{temp_path}/puppeteer_#{random_string}.js"
      js_code = "const puppeteer = require('puppeteer');
                      (async () => {
                          const browser = await puppeteer.launch();
                          const page = await browser.newPage();
                          await page.setViewport({ width: #{page_height}, height: #{page_width} })
                          await page.goto('#{url}', {waitUntil: 'networkidle2', timeout: #{timeout}});
                          await page.pdf({path: '#{output_file_path}', format: '#{format}', width: '#{page_width}px', height: '#{page_height}px', layout: '#{page_layout}' , printBackground: #{print_background}, displayHeaderFooter: #{need_to_display_headers},
  margin: {top: 10, bottom: 40}, headerTemplate: '<span>#{header_text}</span>' });
                          await browser.close();
                    })();"
      file = File.open(tmp_js_file_name, "w")
      file.puts js_code
      file.close
      system("node #{tmp_js_file_name}") # GENERATE EXPORT
      system("rm -rf #{tmp_js_file_name}")
      color_coding("############################################################################################################", 'blue')
      color_coding("PDF IS GENERATED : #{output_file_path}", 'green')
      color_coding("############################################################################################################", 'blue')
      output_file_path
  end

  def self.generate_random_string
    SecureRandom.alphanumeric[0..5]
  end
end
