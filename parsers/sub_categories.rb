body = JSON.parse(content)
body_json = JSON.parse(body.to_json)
vars = page['vars']

products = body_json['data']['productSearch']['products']
# require 'byebug'
# byebug
products.each_with_index do |prod, i|
    categories = prod['categories']
    measurement_body = ''
    sku_body = ''
    country_origin = nil
    prod['specificationGroups'].each_with_index do |spec_body, idx|
        # require 'byebug'
        # byebug
        if spec_body['name'] == 'Configuraciones'
            if idx == 1
                measurement_body = JSON.parse(spec_body['specifications'][0]['values'].first) rescue nil
                sku_body = JSON.parse((spec_body['specifications'][1]['values'].first).to_json) rescue nil
            else
                sku_body = JSON.parse((spec_body['specifications'][0]['values'].first).to_json)
            end
        end
    end

    item_id = prod['items'][0]['itemId']
    sku = sku_body["#{item_id}"]['ref_id'] rescue nil

    available_qty = prod['items'][0]['sellers'][0]['commertialOffer']['AvailableQuantity']
    if available_qty > 0
        is_available = true
    else
        is_available = false
    end
    img_url = prod['items'][0]['images'][0]['imageUrl'].downcase
    category = categories.last.gsub('/','')
    sub_category_arr = categories[0].split('/')
    sub_category = []
    sub_category_arr.each do |sub_cat|
        if sub_cat != category && !sub_cat.empty?
            sub_category.push(sub_cat)
        end
    end

    sub_category = sub_category.join(' > ')
    
    url = 'https://www.disco.com.ar' + prod['link'].downcase
    # byebug
    out = {
        '_collection' => 'items',
        '_id' => prod['productId'],
        'competitor_name' => 'Disco',
        'competitor_type' => 'dmart',
        'store_name' => "Disco Argentina",
        'store_id' => '1',
        'country_iso' => 'AR',
        'language' => 'ENG',
        'currency_code_lc' => 'ARS',
        'scraped_at_timestamp' => Time.now().to_s.gsub(/([+]\S+)/, '').strip,
        'competitor_product_id' => prod['productId'],
        'name' => prod['productName'].downcase,
        'brand' => prod['brand'],
        'category_id' => prod['categoryId'],
        'category' => category, #don't forget to change this category name
        'sub_category' => sub_category,
        'rank_in_listing' => i + 1,
        'page_number'=> 1,
        'product_pieces' => nil,
        'size_std' => nil,
        'size_unit_std' => nil,
        'description' => prod['description'].downcase,
        'img_url'=> img_url,
        'sku'=> nil,
        'url'=> url,
        'barcode' => prod['productId'],
        'is_available' => is_available,
        'crawled_source'=>'WEB',
        'latitude' => nil,
        'longitude' => nil,
        'reviews' => nil,
        'store_reviews'=> nil,
        'item_identifiers'=> ({'barcode': "'#{prod['productId']}'"}).to_json,
        'country_of_origin'=> country_origin,
        'variants'=> nil,
    }
    
    pages << {
        url: url,
        page_type: "details",
        http2: trueß,
        fetch_type: 'browser',
        method: "GET",
        # cookie: page['headers']["cookie"],
        headers: page['headers'],
        vars: {
            out: out,
        },
    }
end

totalProd = body_json['data']['productSearch']['recordsFiltered']
lastPage = (totalProd.to_f/20).ceil()
# require 'byebug'
# byebug
start_count = (vars['page_num'].to_i * 20).to_s
last_count = (start_count.to_i + vars['page_num'].to_i * 20 - 1).to_s
# byebug
if vars['page_num'] < lastPage
    variables = JSON.parse('{"hideUnavailableItems":true,"skusFilter":"FIRST_AVAILABLE","simulationBehavior":"default","installmentCriteria":"MAX_WITHOUT_INTEREST","productOriginVtex":false,"map":"c,c","query":"'+ vars['cat_name'] +'/'+ vars['category'] +'","orderBy":"OrderByScoreDESC","from":'+ start_count +',"to":'+ last_count +',"selectedFacets":[{"key":"c","value":"'+ vars['cat_name'] +'"},{"key":"c","value":"'+ vars['category'] +'"}],"operator":"and","fuzzy":"0","searchState":null,"facetsBehavior":"Static","categoryTreeBehavior":"default","withFacets":false}')
    encoded_variables = Base64.strict_encode64(JSON.generate(variables))
    url = 'https://www.disco.com.ar/_v/segment/graphql/v1?workspace=master&maxAge=short&appsEtag=remove&domain=store&locale=es-AR&__bindingId=0beab475-23b8-4674-b38a-956cc988dade&operationName=productSearchV3&variables={}&extensions={"persistedQuery":{"version":1,"sha256Hash":"67d0a6ef4d455f259737e4edb1ed58f6db9ff823570356ebc88ae7c5532c0866","sender":"vtex.store-resources@0.x","provider":"vtex.search-graphql@0.x"},"variables":"'+encoded_variables+'"}'

    pages << {
        url: url,
        page_type: "sub_categories",
        http2: true,
        method: "GET",
        headers: page['headers'],
        vars: {
            url_variables: variables,
            cat_name: vars['cat_name'],
            category: vars['category'],
            page_num: vars['page_num'] + 1,
        },
    }
end