html = Nokogiri::HTML(content)
vars = page['vars']
out = vars['out']

script = html.css('script[type="application/ld+json"]').text rescue nil
json = JSON.parse(script)
