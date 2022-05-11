body = JSON.parse(content)
# require 'byebug'
products = body['data']['productSearch']['products']
products.each_with_index do |prod, i|
    categories = prod['categories']
    
    category = categories.last.gsub('/','')
    sub_category_arr = categories[0].split('/')
    sub_category = []
    sub_category_arr.each do |sub_cat|
        if sub_cat != category && !sub_cat.empty?
            sub_category.push(sub_cat)
        end
    end
    # byebug
    sub_category = sub_category.join('>')
    
    url = 'https://www.disco.com.ar' + prod['link']

    out = {
        'competitor_name' => 'Disco',
        'competitor_type' => 'Local_Store',
        'store_name' => "Disco",
        'store_id' => nil,
        'country_iso' => 'AR',
        'language' => 'ENG',
        'currency_code_lc' => 'ARS',
        'scraped_at_timestamp' => Time.now().to_s.gsub(/([+]\S+)/, '').strip,
        'competitor_product_id' => nil,
        'name' => prod['productName'],
        'brand' => prod['brand'],
        'category_id' => prod['categoryId'],
        'category' => category, #don't forget to change this category name
        'sub_category' => sub_category,
        'customer_price_lc' => nil,
        'base_price_lc' => nil,
        'has_discount' => nil,
        'discount_percentage' => nil,
        'rank_in_listing' => i + 1,
        'page_number'=> 1,
        'product_pieces' => nil,
        'size_std' => nil,
        'size_unit_std' => nil,
        'description' => prod['description'],
        'img_url'=> nil,
        'barcode'=> nil,
        'sku'=> nil,
        'url'=> url,
        'is_available' => nil,
        'crawled_source'=>'WEB',
        'is_promoted' => nil,
        'type_of_promotion' => nil,
        'promo_attributes'=> nil,
        'is_private_label' => nil,
        'latitude' => nil,
        'longitude' => nil,
        'reviews' => nil,
        'store_reviews'=> nil,
        'item_attributes'=> nil,
        'item_identifiers'=> nil,
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