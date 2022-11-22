require "./lib/helpers"
require "./lib/sha256hash"


def jp(text)
    puts JSON.pretty_generate(text)
end

is_full_run = false
if ENV['is_full_run'] == 'true' 
    is_full_run = true
end

# region_id = ENV['region_id']
# if !region_id
#     region_id = "MDE"
# end
# region_string = Helpers::region_id[region_id]['id']

json = JSON.parse(content)

# if !is_full_run
#     # cut categories by half 3 times
#     json = json.select.with_index{|_,i| (i+1) % 2 == 0}.select.with_index{|_,i| (i+1) % 2 == 0}
# end


top_level = json

i = 0
top_level.each do |j|
    if j
        # transverse_facets(j['children']) 
        # p URI::parse(j['url']).path.split('/').select{|i| i != ''}
        

        root_name = j['name']
        slug = j['url'].gsub(/https?:\/\/[^\/]+\//, "").strip

        slug_array = URI::parse(slug).path.split('/')
        # p slug

        selected_facets = slug_array.map{|i| '{"key":"c","value":"' + i + '"}'}.join(',')
        selected_facets = '"selectedFacets":[' + selected_facets + ']'
        # puts selected_facets

        map = slug_array.map{|i| 'c'}.join(',')
        # puts map


        variables = '{"hideUnavailableItems":true,"behavior":"Static","categoryTreeBehavior":"default","query":"' + "#{slug}" + '","map":"' + map + '",' + selected_facets + ',"initialAttributes":"' + map + '"}'
        # puts variables
        
        variables_encoded = Base64.strict_encode64(variables)
        # puts variables_encoded

        # NOTE: check the sha256Hash below if scraper fail
        url = Helpers::website + '/_v/segment/graphql/v1?appsEtag=remove&domain=store&extensions={"persistedQuery":{"version":1,"sha256Hash":"' + Sha256Hash::hash['facetsV2'] + '","sender":"vtex.store-resources@0.x","provider":"vtex.search-graphql@0.x"},"variables":"' + variables_encoded + '"}&locale=es-CO&maxAge=medium&operationName=facetsV2&variables={}&workspace=master'
        # puts url


        pages << {
            url: url,
            page_type: "before_listings",
            http2: true,
            priority: 20,
            method: "GET",
            fetch_type: "standard",
            headers: {
                'Cookie' => page['vars']['cookie'],
                'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36',
                "Accept-Encoding" => "gzip, deflate, br",
                "Accept" => "*/*",
            },
            vars: {
                parent_gid: page['gid'],
                categories: [root_name],
                slug: [slug],
                params: JSON.parse(variables),
                cookie: page['vars']['cookie'],
                category_id: j['id'],
            }
        }

        # if !is_full_run # sample limit
        #     if i >= 3
        #         break
        #     end
        # end
        # i = i + 1

        # j['children'].each do |jc|
        #     p URI::parse(jc['url']).path.split('/').select{|i| i != ''}
        # end
    else
        # p URI::parse(j['url']).path.split('/')
        raise 'errror'
    end

end