require "./lib/helpers"
require "./lib/sha256hash"


json = JSON.parse(content)

# get region for the scraper
# region_id = ENV['region_id']
# if !region_id
#     region_id = "MDE"
# end
# region_string = Helpers::region_id[region_id]['id']

# full or sample run, default to sample
is_full_run = false
if ENV['is_full_run'] == 'true' 
    is_full_run = true
end

breadcrumb = json['data']['facets']['breadcrumb']
cookie = page['vars']['cookie']

i = 1
if !json['data']['facets']['facets'].empty?
    filters = json['data']['facets']['facets'].select { |c| c['name'] =~ /Marca/i}
    
    if !filters.empty?

        filters.first['facets'].each do |filter|
            # raise 'error'

            slug = filter['value']
            href = filter['href']
            name = filter['name']
            # puts "slug: #{slug}"

            param_example = [
                '{"hideUnavailableItems":false,"skusFilter":"ALL","simulationBehavior":"default","installmentCriteria":"MAX_WITHOUT_INTEREST","productOriginVtex":false,"map":"c,c,c,brand","query":"hogar/decoracion/cuadros/art-industry","orderBy":"OrderByScoreDESC","from":0,"to":20,"selectedFacets":[{"key":"c","value":"hogar"},{"key":"c","value":"decoracion"},{"key":"c","value":"cuadros"},{"key":"brand","value":"art-industry"}],"operator":"and","fuzzy":"0","searchState":null,"facetsBehavior":"dynamic","categoryTreeBehavior":"default","withFacets":false}'
            ]
            new_slug = "#{page['vars']['params']['query']}/#{slug}"
            
            

            old_facets = Marshal.load(Marshal.dump("selectedFacets" => page['vars']['params']['selectedFacets'])) #copy
            new_selected_facets = JSON.generate("selectedFacets" => old_facets['selectedFacets'] << {"key" => "brand", "value" => slug})
            # puts new_slug
            # puts new_selected_facets

            # puts ''
            map = page['vars']['params']['map'] + ',' + filter['key']

            variables = '{"hideUnavailableItems":false,"skusFilter":"ALL","simulationBehavior":"default","installmentCriteria":"MAX_WITHOUT_INTEREST","productOriginVtex":false,"map":"' + map + '","query":"' + new_slug + '","orderBy":"OrderByScoreDESC","from":0,"to":20,' + new_selected_facets.gsub(/^\{|\}$/,'') + ',"operator":"and","fuzzy":"0","searchState":null,"facetsBehavior":"dynamic","categoryTreeBehavior":"default","withFacets":false}'
            # puts variables
            # puts JSON.parse(variables)

            variables_encoded = Base64.strict_encode64(variables)
            # puts variables_encoded

            url = 'https://www.exito.com/_v/segment/graphql/v1?workspace=master&maxAge=short&appsEtag=remove&domain=store&locale=es-CO&operationName=productSearchV3&variables={}&extensions={"persistedQuery":{"version":1,"sha256Hash":"' + Sha256Hash::hash['productSearchV3'] + '","sender":"vtex.store-resources@0.x","provider":"vtex.search-graphql@0.x"},"variables":"' + variables_encoded + '"}'
            # if name == 'FINLANDEK'
            #     puts url
            #     exit!
            # end

            pages << {
                url: url,
                page_type: "listings",
                http2: true,
                priority: 10,
                method: "GET",
                fetch_type: "standard",
                headers: {
                    'Cookie' => cookie,
                    'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36',
                    "Accept-Encoding" => "gzip, deflate, br",
                    "Accept" => "*/*",
                },
                vars: {
                    parent_gid: page['gid'],
                    categories: (page['vars']['categories'] + [name]),
                    category_id: page['vars']['category_id'],
                    slug: new_slug,
                    params: JSON.parse(variables),
                    cookie: cookie,
                    first_page: true,
                    using_brand_filter: true,
                }
            }
            
            # reg
                    
        end

    else
        raise "No sub-categories found"
    end
else
    raise "something is wrong"
end