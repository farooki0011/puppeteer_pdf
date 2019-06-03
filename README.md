# PuppeteerPdf

PuppeteerPdf is using Puppeteer library organized by Google. It's a lightest gem to generate PDF's using 
URL. PuppeteerPdf is using Headless to open webpage and then simply convert it into PDF. 
### Prerequisite

Before installing puppeteer_pdf gem system must have puppeteer library installed, it can be installed by

```
- nvm install 8
- npm i puppeteer  # or "yarn add puppeteer"

```

 or visit https://developers.google.com/web/tools/puppeteer/
 
## Installation

Once all prerequisites are installed add this line to your application's Gemfile:

```ruby
gem 'puppeteer_pdf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puppeteer_pdf

## Usage

```ruby
require 'puppeteer_pdf'
url = 'https://developers.google.com/web/tools/puppeteer'
output_path = '/system_path/test.pdf'
PuppeteerPdf.generate_pdf(url, output_path) # '/system_path/test.pdf'
```

## Options 

```ruby
opts = {
    height: 600,
    width: 1225,
    layout: 'Landscape',
    format: 'A4',
    timeout: 10000,
    header_text: 'Company Name',
    footer_text: 'Any Text Information',
    print_background: true,
    include_page_numbers: true,
    {
PuppeteerPdf.generate_pdf(url, output_path, opts)

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/muneeb0011/puppeteer_pdf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PuppeteerPdf project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/puppeteer_pdf/blob/master/CODE_OF_CONDUCT.md).
