require "./lib/helpers"
require "./lib/sha256hash"

is_full_run = false
if ENV['is_full_run'] == 'true' 
    is_full_run = true
end

#Decode cookie and set region
cookie = page['response_cookie']
if !cookie || cookie.empty?
    raise 'No cookie found'
end

pages << {
    url: 'https://www.disco.com.uy/api/sessions?sc=33',
    page_type: "set_location",
    headers: {
        'accept': '*/*',
        'accept-language': 'en-US,en;q=0.9',
        'cache-control': 'no-cache',
        'cookie': cookie,
        'content-type': 'application/json',
        'origin': 'https://www.disco.com.uy',
        'pragma': 'no-cache',
        'referer': 'https://www.disco.com.uy/',
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 Edg/107.0.1418.52'
      },
    # body: '{"public":{"buyselectMethod":{"value":"recogida"},"regionId":{"value":"U1cjanVtYm9hcmdlbnRpbmFkMDM1"}}}',
    body: '{"public":{"country":{"value":"URY"},"geoCoordinates":{"value":"-56.18187519999999,-34.914079"}}}',
    method: "POST",
    http2: true,
    fetch_type: "standard",
    vars: {
        cookie: cookie,
    },
}