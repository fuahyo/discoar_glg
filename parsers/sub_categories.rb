body = JSON.parse(content)
# require 'byebug'

products = body['data']['productSearch']['products']
products.each_with_index do |prod, i|
    categories = prod['categories']
    measurement_body = ''
    sku_body = ''
    prod['specificationGroups'].each_with_index do |spec_body, j|
        if spec_body['name'] == 'Configuraciones'
            measurement_body = JSON.parse(spec_body['specifications'][0]['values'].first)
            sku_body = JSON.parse(spec_body['specifications'][1]['values'].first)
        end
    end
    # byebug
    item_size = measurement_body['unit_multiplier_un']
    uom = measurement_body['measurement_unit_un']
    product_pieces = measurement_body['unit_multiplier']

    item_id = prod['items'][0]['itemId']
    sku = sku_body["#{item_id}"]['ref_id']

    available_qty = prod['items'][0]['sellers'][0]['commertialOffer']['AvailableQuantity']
    if available_qty > 0
        is_available = true
    else
        is_available = false
    end
    img_url = prod['items'][0]['images'][0]['imageUrl']
    category = categories.last.gsub('/','')
    sub_category_arr = categories[0].split('/')
    sub_category = []
    sub_category_arr.each do |sub_cat|
        if sub_cat != category && !sub_cat.empty?
            sub_category.push(sub_cat)
        end
    end

    sub_category = sub_category.join(' > ')
    
    url = 'https://www.disco.com.ar' + prod['link']
    # byebug
    out = {
        '_collection' => 'items',
        '_id' => prod['productId'],
        'competitor_name' => 'Disco',
        'competitor_type' => 'dmart',
        'store_name' => "Disco Argantina",
        'store_id' => '1',
        'country_iso' => 'AR',
        'language' => 'ENG',
        'currency_code_lc' => 'ARS',
        'scraped_at_timestamp' => Time.now().to_s.gsub(/([+]\S+)/, '').strip,
        'competitor_product_id' => prod['productId'],
        'name' => prod['productName'],
        'brand' => prod['brand'],
        'category_id' => prod['categoryId'],
        'category' => category, #don't forget to change this category name
        'sub_category' => sub_category,
        'rank_in_listing' => i + 1,
        'page_number'=> 1,
        'product_pieces' => product_pieces,
        'size_std' => item_size,
        'size_unit_std' => uom,
        'description' => prod['description'],
        'img_url'=> img_url,
        'sku'=> sku,
        'url'=> url,
        'barcode' => prod['productId'],
        'is_available' => is_available,
        'crawled_source'=>'WEB',
        'latitude' => nil,
        'longitude' => nil,
        'reviews' => nil,
        'store_reviews'=> nil,
        'item_identifiers'=> ({'barcode': "'#{prod['productId']}'"}).to_json,
        'country_of_origin'=> nil,
        'variants'=> nil,
    }
    
    pages << {
        url: url,
        page_type: "details",
        http2: false,
        fetch_type: 'browser',
        method: "GET",
        headers: page['headers'],
        vars: {
            out: out,
        },
    }
end