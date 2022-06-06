html = Nokogiri::HTML(content)
vars = page['vars']
out = vars['out']

script = html.css('script[type="application/ld+json"]')[0].text

json = JSON.parse(script)

prod_detail = html.css('div div.vtex-flex-layout-0-x-flexRow .vtex-flex-layout-0-x-flexRow--mainRow-price-box')
flag = prod_detail.css('.discoargentina-store-theme-WkYYQ7ZTERgAVs_fNdXNH').text rescue nil
# require 'byebug'
# byebug
if flag.empty?
    base_price_lc = json['offers']['highPrice']
    customer_price_lc = base_price_lc
    is_promoted = false
    has_discount = false
elsif !flag.empty? && flag.include?("do al") || !flag.include?('%') && flag.include?('x')
    has_discount = false
    is_promoted = true
    base_price_lc = json['offers']['highPrice']
    customer_price_lc = base_price_lc
    type_of_promotion = 'Banner'
    promo_attributes = {
        "promo_detail": "'#{flag}'"
    }.to_json
elsif !flag.empty?
    has_discount = true
    is_promoted = true
    type_of_promotion = 'Banner'
    base_price_lc = json['offers']['highPrice']
    string_percent = flag.scan(/(\d+)%.*/).first.first

    customer_price_lc = (base_price_lc.to_f - (base_price_lc.to_f * string_percent.to_f)/100).to_s
    discount_percentage = ((string_percent.to_f).round(7)).to_s
    promo_attributes = {
        "promo_detail": "'#{flag.scan(/(\d+%).*/).first.first}'"
    }.to_json
end
# require 'byebug'
# byebug
country_origin = ''
if out['country_of_origin'].nil?
    if !html.css('.vtex-product-specifications-1-x-specificationName').nil?
        html.css('.vtex-product-specifications-1-x-specificationName').each_with_index do |specName,i|
            if specName.text == "Origen"
                country_origin = html.css('.vtex-product-specifications-1-x-specificationValue--last')[i].text
            end
        end
    end
    # byebug
end

outputs << {
    'competitor_name' => nil,
    'competitor_type' => nil,
    'store_name' => nil,
    'store_id' => nil,
    'country_iso' => nil,
    'language' => nil,
    'currency_code_lc' => nil,
    'scraped_at_timestamp' => nil,
    'competitor_product_id' => nil,
    'name' => nil,
    'brand' => nil,
    'category_id' => nil,
    'category' => nil,
    'sub_category' => nil,
    'customer_price_lc' => customer_price_lc,
    'base_price_lc' => base_price_lc,
    'has_discount' => has_discount,
    'discount_percentage' => discount_percentage,
    'rank_in_listing' => nil,
    'page_number'=> nil,
    'product_pieces' => nil,
    'size_std' => nil,
    'size_unit_std' => nil,
    'description' => nil,
    'img_url'=> nil,
    'barcode'=> nil,
    'sku'=> nil,
    'url'=> nil,
    'is_available' => nil,
    'crawled_source'=>'WEB',
    'is_promoted' => is_promoted,
    'type_of_promotion' => type_of_promotion,
    'promo_attributes'=> promo_attributes.nil? ? nil : promo_attributes,
    'is_private_label' => false,
    'latitude' => nil,
    'longitude' => nil,
    'reviews' => nil,
    'store_reviews'=> nil,
    'item_attributes'=> nil,
    'item_identifiers'=> nil,
    'country_of_origin'=> nil,
    'variants'=> nil,
}.merge(out)