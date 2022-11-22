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
    url: 'https://www.superxtra.com/api/sessions',
    page_type: "set_location",
    headers: {
        'authority': 'www.superxtra.com',
        'accept': '*/*',
        'accept-language': 'en-US,en;q=0.9',
        'cache-control': 'no-cache',
        'cookie': cookie,
        'content-type': 'application/json',
        'origin': 'https://www.superxtra.com',
        'pragma': 'no-cache',
        'referer': 'https://www.superxtra.com/',
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36 Edg/106.0.1370.34'
      },
    body: '{"public":{"country":{"value":"PAN"},"geoCoordinates":{"value":"-79.5211498,8.9913002"}}}',
    method: "POST",
    fetch_type: "standard",
    vars: {
        cookie: cookie,
    },
}