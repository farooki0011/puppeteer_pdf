require "puppeteer_pdf/version"
require 'securerandom'

module PuppeteerPdf
  class Error < StandardError; end

  def self.generate_pdf(url, output_file_path ,opts = {})
      random_string = generate_random_string
      raise "INVALID PATH, Hint : (/path/file.pdf)" unless output_file_path.include?('.pdf')
      temp_path = output_file_path.reverse.split('/',2)[1].reverse
      tmp_js_file_name = "#{temp_path}/puppeteer_#{random_string}.js"
      js_code = "const puppeteer = require('puppeteer');
                      (async () => {
                          const browser = await puppeteer.launch();
                          const page = await browser.newPage();
                          await page.setViewport({ width: 1125, height: 600 })
                          await page.goto('#{url}', {waitUntil: 'networkidle2'});
                          await page.pdf({path: '#{output_file_path}', width: '1125px', height: '700px', layout: 'Landscape' , printBackground: true, displayHeaderFooter: true,
  margin: {top: 10, bottom: 40}, headerTemplate: '<span></span>' });
                          await browser.close();
                    })();"
      file = File.open(tmp_js_file_name, "w")
      file.puts js_code
      file.close
      system("node #{tmp_js_file_name}") # GENERATE EXPORT
      system("rm -rf #{tmp_js_file_name}")
  end

  def self.generate_random_string
    SecureRandom.alphanumeric[0..5]
  end
end
