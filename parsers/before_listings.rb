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
    sub_cats = json['data']['facets']['facets'].select { |c| c['name'] =~ /sub-?categor.a/i}
    if !sub_cats.empty?

        sub_cats.first['facets'].each do |sub_cat|
            if !sub_cat['key'] =~ /category\-3/i
                raise 'error: sub_cat["key"] is not "category-3", might need more work'
            end


            slug = sub_cat['value']
            href = sub_cat['href']
            name = sub_cat['name']
            # puts "slug: #{slug}"

            # {"hideUnavailableItems":false,"skusFilter":"ALL","simulationBehavior":"default","installmentCriteria":"MAX_WITHOUT_INTEREST","productOriginVtex":false,"map":"c,c,c","query":"bebidas-pasabocas-y-dulces/bebidas/gaseosas","orderBy":"OrderByScoreDESC","from":0,"to":20,"selectedFacets":[{"key":"c","value":"bebidas-pasabocas-y-dulces"},{"key":"c","value":"bebidas"},{"key":"c","value":"gaseosas"}],"operator":"and","fuzzy":"0","searchState":null,"facetsBehavior":"Static","categoryTreeBehavior":"default","withFacets":false}

            new_slug = "#{page['vars']['params']['query']}/#{slug}"
            
            old_facets = Marshal.load(Marshal.dump("selectedFacets" => page['vars']['params']['selectedFacets'])) #copy
            new_selected_facets = JSON.generate("selectedFacets" => old_facets['selectedFacets'] << {"key" => sub_cat['key'], "value" => slug})
            # puts new_slug
            # puts new_selected_facets

            variables = '{"hideUnavailableItems":false,"skusFilter":"ALL","simulationBehavior":"default","installmentCriteria":"MAX_WITHOUT_INTEREST","productOriginVtex":false,"map":"c,' + sub_cat['key'] + '","query":"' + new_slug + '","orderBy":"OrderByScoreDESC","from":0,"to":20,' + new_selected_facets.gsub(/^\{|\}$/,'') + ',"operator":"and","fuzzy":"0","searchState":null,"facetsBehavior":"Static","categoryTreeBehavior":"default","withFacets":false}'
            # puts ''
            # puts variables
            # puts JSON.parse(variables)

            variables_encoded = Base64.strict_encode64(variables)
            # puts variables_encoded

            url = Helpers::website + '/_v/segment/graphql/v1?workspace=master&maxAge=short&appsEtag=remove&domain=store&locale=es-CO&operationName=productSearchV3&variables={}&extensions={"persistedQuery":{"version":1,"sha256Hash":"' + Sha256Hash::hash['productSearchV3'] + '","sender":"vtex.store-resources@0.x","provider":"vtex.search-graphql@0.x"},"variables":"' + variables_encoded + '"}'
            # puts url
            # exit!

            pages << {
                url: url,
                page_type: "listings",
                http2: true,
                method: "GET",
                priority: 10,
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
                    slug: (page['vars']['slug'] + [slug]),
                    params: JSON.parse(variables),
                    cookie: cookie,
                    category_id: page['vars']['category_id'],
                    first_page: true,
                    page_number: 1,
                }
            }
            


            if !is_full_run #### sample limit
                if i >= 15
                    break
                end
            end
            i = i + 1        
        end
    elsif json['data']['facets']['breadcrumb'].first['href'] =~ /^\/tarjeta-regalo$/i
        puts "[SKIP]: tarjeta regalo, skip this category, its a custom category on the page (no products)"

    else
        # raise 'edge case: CODE HASN\'T BEEN TESTED'

        category_2 = json['data']['facets']['facets'].select { |c| c['name'] =~ /Categor.a/i}
        if category_2.empty?
            finish if page['vars']['slug'].first == "no-corresponde"
            finish if page['vars']['slug'].first == "sin-categoria"

            raise "error: category_2 is empty, need more work"
        end
        
        category_2.first['facets'].each do |cat|    
            slug = cat['value']
            href = cat['href']
            name = cat['name']
            # puts "slug: #{slug}"

            # {"hideUnavailableItems":false,"skusFilter":"ALL","simulationBehavior":"default","installmentCriteria":"MAX_WITHOUT_INTEREST","productOriginVtex":false,"map":"c,c,c","query":"bebidas-pasabocas-y-dulces/bebidas/gaseosas","orderBy":"OrderByScoreDESC","from":0,"to":20,"selectedFacets":[{"key":"c","value":"bebidas-pasabocas-y-dulces"},{"key":"c","value":"bebidas"},{"key":"c","value":"gaseosas"}],"operator":"and","fuzzy":"0","searchState":null,"facetsBehavior":"Static","categoryTreeBehavior":"default","withFacets":false}

            new_slug = "#{page['vars']['params']['query']}/#{slug}"
            
            old_facets = Marshal.load(Marshal.dump("selectedFacets" => page['vars']['params']['selectedFacets'])) #copy
            new_selected_facets = JSON.generate("selectedFacets" => old_facets['selectedFacets'] << {"key" => cat['key'], "value" => slug})
            # puts new_slug
            # puts new_selected_facets

            variables = '{"hideUnavailableItems":false,"skusFilter":"ALL","simulationBehavior":"default","installmentCriteria":"MAX_WITHOUT_INTEREST","productOriginVtex":false,"map":"c,' + cat['key'] + '","query":"' + new_slug + '","orderBy":"OrderByScoreDESC","from":0,"to":20,' + new_selected_facets.gsub(/^\{|\}$/,'') + ',"operator":"and","fuzzy":"0","searchState":null,"facetsBehavior":"Static","categoryTreeBehavior":"default","withFacets":false}'
            # puts ''
            # puts variables
            # puts JSON.parse(variables)

            variables_encoded = Base64.strict_encode64(variables)
            # puts variables_encoded

            url = Helpers::website + '/_v/segment/graphql/v1?workspace=master&maxAge=short&appsEtag=remove&domain=store&locale=es-CO&operationName=productSearchV3&variables={}&extensions={"persistedQuery":{"version":1,"sha256Hash":"' + Sha256Hash::hash['productSearchV3'] + '","sender":"vtex.store-resources@0.x","provider":"vtex.search-graphql@0.x"},"variables":"' + variables_encoded + '"}'
            puts url
            # exit!

            pages << {
                url: url,
                page_type: "listings",
                http2: true,
                method: "GET",
                priority: 10,
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
                    slug: (page['vars']['slug'] + [slug]),
                    params: JSON.parse(variables),
                    cookie: cookie,
                    category_id: page['vars']['category_id'],
                    first_page: true,
                    page_number: 1,
                }
            }
        end
    end

    
else
    puts 'categories.rb: categories empty, probably not showing on the web'
end