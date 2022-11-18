html = Nokogiri::HTML(content)
# vars = page['vars']
out = vars['out']

if content.include? 'PAGE NOT FOUND'
    total_refetch = (vars["total_refetch"].nil?) ? 1 : vars["total_refetch"] + 1
    if total_refetch < 10
        pages << {
            url: page['url'],
            page_type: "details",
            http2: false,
            method: "GET",
            fetch_type: "browser",
            headers: page['headers'],
            vars: vars.merge({
                "total_refetch" => total_refetch,
            }),
        }
    else
        out['_collection'] = 'page not found'
        output << out
    end

else

    script = html.css('script[type="application/ld+json"]')[0].text

    json = JSON.parse(script)
    # html.css('.vtex-flex-layout-0-x-flexColChild.vtex-flex-layout-0-x-flexColChild--separator.vtex-flex-layout-0-x-flexColChild--product-box.pb0').text
    prod_detail = html.css('div div.vtex-flex-layout-0-x-flexRow .vtex-flex-layout-0-x-flexRow--mainRow-price-box')
    flag = prod_detail.css('.discoargentina-store-theme-WkYYQ7ZTERgAVs_fNdXNH').text rescue nil
    if flag.include?('x') && flag.include?('%')
        flag = flag.scan(/(\d+\s?x\s?\d?).*/).first.first
    end

    require 'byebug'
    byebug
    if flag.empty?
        base_price_lc = json['offers']['highPrice']
        customer_price_lc = base_price_lc
        is_promoted = false
        has_discount = false
    elsif !flag.empty? && flag.include?("do al") || !flag.include?('%') && flag.include?('x')
        # require 'byebug'
        # byebug
        has_discount = false
        is_promoted = true
        base_price_lc = json['offers']['highPrice']
        customer_price_lc = base_price_lc
        type_of_promotion = 'Banner'
        if flag.include?("do al")
            promo_attributes = {
                "promo_detail": "'#{flag.scan(/(\d+\s?do al \d+%).*/).first.first}'"
            }.to_json
        elsif flag.include?("x")
            promo_attributes = {
                "promo_detail": "'#{flag.scan(/(\d+\s?x\s?\d+).*/).first.first}'"
            }.to_json
        end
    elsif !flag.empty?
        has_discount = true
        is_promoted = true
        type_of_promotion = 'Banner'
        base_price_lc = json['offers']['highPrice']
        string_percent = flag.scan(/(\d+)%.*/).first.first rescue nil

        customer_price_lc = (base_price_lc.to_f - (base_price_lc.to_f * string_percent.to_f)/100).to_s
        discount_percentage = ((string_percent.to_f).round(7)).to_s
        promo_attributes = {
            "promo_detail": "'#{string_percent}%'"
        }.to_json
    end

    country_origin = ''
    if out['country_of_origin'].nil?
        if !html.css('.vtex-product-specifications-1-x-specificationName').nil?
            html.css('.vtex-product-specifications-1-x-specificationName').each_with_index do |specName,i|
                if specName.text == "Origen"
                    out['country_of_origin'] = html.css('.vtex-product-specifications-1-x-specificationValue--last')[i].text
                end
            end
        end
        # byebug
    end

    item_size = ''
    uom = ''

    if out['name'].include?('Six Pack') || out['name'].include?('Sixpack')
        out['product_pieces'] = '6'
    else
        out['product_pieces'] = '1'
    end

    product_pieces_regex = [
        /(\d+)\s?per\s?pack/i,
        /(\d+)\s?pack/i,
        /(\d+)\s?pcs?/i,
        /(\d+)\s?unidades?/i,
        /(\d+)\s?und?/i,
        /(\d+)\s?un?/i,
        /(\d+)\s?unid?/i,
        /(\d+)\s?uds?/i,
        /(\d+)\s?sobres/i,
        /(\d+)\s?paq/i,
        /(\d+)\s?tabletas/i,
    ].find {|ppr| out['name'].downcase =~ ppr}
    out['product_pieces'] = $1
    out['product_pieces'] = '1' if out['product_pieces'].nil?

    regexps = [
        /(\d*[\.,]?\d+)\s?([Ff][Ll]\.?\s?[Oo][Zz])/,
        /(\d*[\.,]?\d+)\s?(lt)/,
        /(\d*[\.,]?\d+)\s?([Oo][Zz])/,
        /(\d*[\.,]?\d+)\s?([Ff][Oo])/,
        /(\d*[\.,]?\d+)\s?([Ee][Aa])/,
        /(\d*[\.,]?\d+)\s?([Ff][Zz])/,
        /(\d*[\.,]?\d+)\s?(Fluid Ounces?)/,
        /(\d*[\.,]?\d+)\s?([Oo]unce)/,
        /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
        /(\d*[\.,]?\d+)\s?([Cc][Ll])/,
        /(\d*[\.,]?\d+)\s?([Ll]\z)/,
        /(\d*[\.,]?\d+)\s?([Gg]\z)/,
        /(\d*[\.,]?\d+)\s?([Gg][Rr])/,
        /(\d*[\.,]?\d+)\s?([Ll]itre)/,
        /(\d*[\.,]?\d+)\s?([Ss]ervings)/,
        /(\d*[\.,]?\d+)\s?([Pp]acket\(?s?\)?)/,
        /(\d*[\.,]?\d+)\s?([Cc]apsules)/,
        /(\d*[\.,]?\d+)\s?([Tt]ablets)/,
        /(\d*[\.,]?\d+)\s?([Tt]ubes)/,
        /(\d*[\.,]?\d+)\s?([Cc]hews)/,
        /(\d*[\.,]?\d+)\s?([Mm]illiliter)/i,
        /(\d*[\.,]?\d+)\s?per\s?([Pp]ack)/i,
        /(\d*[\.,]?\d+)\s?([Kk][Gg]\z)/i,
        /(\d*[\.,]?\d+)\s?([Cc][Cc]\z)/i,
        /(\d*[\.,]?\d+)\s?([Mm][Tt]\z)/i,
        /(\d*[\.,]?\d+)\s?([Cc][Mm]\z)/i,
        /(\d*[\.,]?\d+)\s?([Uu]nd)/i,
        # /(\d*[\.,]?\d+)\s?([Mm])/i,
    ]
    regexps.find {|regexp| out['name'].downcase =~ regexp}
    out['size_std'] = $1
    out['size_unit_std'] = $2

    unless out['size_std'].nil?
        out['size_std'] = out['size_std'].gsub(',','.')
    end

    sku = html.css('.vtex-product-identifier-0-x-product-identifier--productReference .vtex-product-identifier-0-x-product-identifier__value').text
    sku = content.scan(/\d\d\d\d\d\d\d\d\d\d\d/).uniq[1] if sku.empty?
    out['sku'] = sku rescue nil
    
    # out['size_unit_std'] = uom
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
        'is_private_label' => true,
        'latitude' => nil,
        'longitude' => nil,
        'reviews' => nil,
        'store_reviews'=> nil,
        'item_attributes'=> nil,
        'item_identifiers'=> nil,
        'country_of_origin'=> nil,
        'variants'=> nil,
    }.merge(out)

    if out['brand']
        variables = JSON.parse('{"hideUnavailableItems":true,"skusFilter":"FIRST_AVAILABLE","simulationBehavior":"default","installmentCriteria":"MAX_WITHOUT_INTEREST","productOriginVtex":false,"map":"ft","query":"'+ out['brand'] +'","orderBy":"OrderByScoreDESC","from":0,"to":20,"selectedFacets":[{"key":"ft","value":"'+ out['brand'] +'"}],"fullText":"'+ out['brand'] +'","operator":"and","fuzzy":"0","searchState":null,"facetsBehavior":"Static","categoryTreeBehavior":"default","withFacets":false}')
        encoded_variables = Base64.strict_encode64(JSON.generate(variables))
        url = 'https://www.disco.com.ar/_v/segment/graphql/v1?workspace=master&maxAge=short&appsEtag=remove&domain=store&locale=es-AR&__bindingId=0beab475-23b8-4674-b38a-956cc988dade&&operationName=productSearchV3&variables={}&extensions={"persistedQuery":{"version":1,"sha256Hash":"67d0a6ef4d455f259737e4edb1ed58f6db9ff823570356ebc88ae7c5532c0866","sender":"vtex.store-resources@0.x","provider":"vtex.search-graphql@0.x"},"variables":"'+encoded_variables+'"}'

        pages << {
            url: url,
            page_type: "brand_search",
            http2: true,
            method: "GET",
            headers: page['headers'],
            vars: {
                url_variables: variables,
                cat_name: vars['cat_name'],
                brand: out['brand'],
                category: out['category'],
                page_num: 1,
            },
        }
    end
end