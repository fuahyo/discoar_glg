require "./lib/helpers"

json = JSON.parse(content)

# region_string = json.first['id']
# raise 'No region found' if !region_string
session = json['sessionToken']
segment = json['segmentToken']


cookie = page['vars']['cookie']
cookie_parts = cookie.split("\;").map{|x| x.strip}

vtex_segment = cookie_parts.detect { |i| i =~ /vtex_segment/ }.split("=").last
cookie_parts.reject! { |i| i =~ /vtex_segment/ }
vtex_session = cookie_parts.detect { |i| i =~ /vtex_session/ }.split("=").last
cookie_parts.reject! { |i| i =~ /vtex_session/ }


# vtex = JSON.parse(Base64.decode64(vtex_segment))
# vtex['regionId'] = region_string 
# new_vtex = Base64.encode64(JSON.generate(vtex)).gsub("\n","")
# puts new_vtex
# exit!

cookie_parts << "vtex_segment=#{segment}"
cookie_parts << "vtex_session=#{session}"

cookie = cookie_parts.join("\; ")


pages << {
    url: Helpers::website + '/api/catalog_system/pub/category/tree/1',
    page_type: "facets",
    http2: true,
    method: "GET",
    fetch_type: "standard",
    vars: {
        cookie: cookie,
    },
}