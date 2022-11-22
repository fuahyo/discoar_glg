require "./lib/helpers"
require "./lib/sha256hash"

json = JSON.parse(content)

# region_id = ENV['region_id']
# if !region_id
#     region_id = "MDE"
# end
cookie = page['vars']['cookie']

is_full_run = false
if ENV['is_full_run'] == 'true' 
    is_full_run = true
end

variables = JSON.generate(page['vars']['params'])
vars = page['vars']

##################### pagination #####################
# get the count
count = json['data']['productSearch']['recordsFiltered']
puts "count: #{count}"



first_page = vars['first_page'] 
# puts first_page
# exit!


using_brand_filter = vars['using_brand_filter'] || false

if count <= 1000 || using_brand_filter
    max_pages = (count / 20.0).ceil

    # loop to change the "to" and "from"
    if first_page
        max_pages = 50 if max_pages > 50
        (2..max_pages).each do |page_num|
            # set upperbound and lowerbound
            from = (page_num - 1) * 20 + (page_num - 1)
            # puts "from: #{from}"
            to = from + 20
            # puts "to: #{to}"

            variables = variables.gsub(/"from"\:\d+/, '"from":' + from.to_s).gsub(/"to"\:\d+/, '"to":' + to.to_s)
            # puts ''
            # puts variables

            variables_encoded = Base64.strict_encode64(variables)
            # puts variables_encoded

            url = Helpers::website + '/_v/segment/graphql/v1?workspace=master&maxAge=short&appsEtag=remove&domain=store&locale=es-CO&operationName=productSearchV3&variables={}&extensions={"persistedQuery":{"version":1,"sha256Hash":"' + Sha256Hash::hash['productSearchV3'] + '","sender":"vtex.store-resources@0.x","provider":"vtex.search-graphql@0.x"},"variables":"' + variables_encoded + '"}'
            # puts url

            vars = page['vars']

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
                vars: (page['vars'].reject{|k,v| k =~ /^params$|^first_page$|^parent_gid$/}
                    .merge({
                        "parent_gid" => page['gid'],
                        "params" => JSON.parse(variables),
                        "first_page" => false,
                        "page_number" => page_num,
                    })
                ),
            }

        end
    end


    # queue product pages

    #{"skipCategoryTree":true,"slug":"mix-cacao-de-origen-y-pretzels-consciente-130-gramo-148747","identifier":{"field":"id","value":"148747"}}


    json['data']['productSearch']['products'].each.with_index(1) do |product, idx|
        id = product['productId']
        name = product['productName']
        raise 'name is nil' if name.nil?

        brand = product['brand']
        category = page['vars']['categories'].first
        category_id = page['vars']['category_id']
        sub_category = product['categories'].first.gsub(/^\/[^\/]+\//,'').gsub(/\/$/,'').split('/').join(' > ')

        # p id

        item = product['items'].find{|it| it['itemId'] == id}
        item ||= product['items'].find{|it| it['name'] == name}
        item ||= product['items'].find{|it| it['nameComplete'] == name}
        item ||= product['items'].find{|it| it['complementName'] == name}
        item ||= product['items'].first


        # require 'byebug'
        # byebug

        raise 'check product["item"]["sellers"]' if (item['sellers']&.length > 1 || item['sellers']&.empty?)


        base_price_lc = Float(item['sellers'].first['commertialOffer']['ListPrice'])
        customer_price_lc = Float(item['sellers'].first['commertialOffer']['Price'])

        store_id = "1"#item['sellers'].first['sellerId']

        base_price_lc = customer_price_lc if base_price_lc < customer_price_lc
        base_price_lc = customer_price_lc if base_price_lc == 0
        has_discount = base_price_lc != customer_price_lc

        discount_percentage = has_discount ? ((1.0 - (customer_price_lc / base_price_lc)) * 100).round(7) : nil

        is_available = item['sellers'].first['commertialOffer']['AvailableQuantity'] > 0



        size_regex = [
            /(?<!\S)(\d*[\.,]?\d+)\s?(litre)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(Litros)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(Galones)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(lt)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(lb)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(Libras)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(Pies³)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(Pies)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(l)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(ml)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(cl)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(gr)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(gl)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(g)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(mg)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\+?\s?(kg)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(oz)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(onz)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(slice[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(sachet[s]?)(?!\S)/i,   
            /(?<!\S)(\d*[\.,]?\d+)\s?(catridge[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(sheet[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(stick[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(bottle[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(caplet[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(roll[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(tip[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(bundle[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(pair[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(set)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(kit)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(pc[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(box)(?!\S)/i,
            #/(?<!\S)(\d*[\.,]?\d+)\s?(s)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(mm)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(cm)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(m)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(page[s]?)(?!\S)/i,
            /(?<!\S)(\d*[\.,]?\d+)\s?(bag)(?!\S)/i,
        ]
        size_regex.find {|sr| name =~ sr}
        std = $1
        size_unit_std = $2
        size_std = std.gsub(',','.').to_f rescue nil
        
        if size_unit_std
            size_unit_std = size_unit_std.downcase
        end
        size_unit_std = 'lt' if size_unit_std == 'litros'
        size_unit_std = 'gl' if size_unit_std == 'galones'
        
        product_pieces_regex = [
            /(\d+)\s?per\s?pack(?!\S)/i,
            /(\d+)\s?pack(?!\S)/i,
            /(\d+)\s?pcs(?!\S)/i,
            /(\d+)\s?unidades?(?!\S)/i,
            /(\d+)\s?und(?!\S)/i,
            /(\d+)\s?uds(?!\S)/i,
            /(\d+)\s?sobres?(?!\S)/i,
            /(\d+)\s?paq(?!\w+)(?!\S)/i,
            /(\d+)\s?tabletas?(?!\S)/i,
            /(\d+)\s?c.psulas?(?!\S)/i,
            /(\d+)\s?Gomitas?(?!\S)/i,
            /(\d+)\s?Rollos?(?!\S)/i,
            /(\d+)\s?piezas?(?!\S)/i,
            /(?<!\S)(\d+)\s?U(?!\S)/i,
        ].find {|ppr| name =~ ppr}
        product_pieces = product_pieces_regex ? $1.to_i : 1
        product_pieces = 1 if product_pieces == 0
        product_pieces ||= 1

        description = product['description']

        img_url = item['images'].first['imageUrl']

        barcode = item['ean']

        url = Helpers::website + product['link']

        # PROMO
        promo_detail = []
        properties = product['properties']
        # if !properties.select{|prop| prop['values'].include?("10 Meses sin intereses")}.empty?
        #     promo_detail << '10 Meses sin intereses'
        # end

        if has_discount
            promo_detail << "-#{(discount_percentage).round}%"
        end

        promo_list = ["Promo PGC"]
        product['clusterHighlights']&.each do |highlight|
            # if highlight['name'] == "Promo PGC"
            promo_detail << highlight['name']
            # end
        end
        
        promo_attributes = nil
        if !promo_detail.empty?
            promo_attributes = {promo_detail: "#{promo_detail.map{|t| "'#{t}'"}.join(', ')}"}.to_json
            type_of_promotion = "badges"
        end
        is_promoted = promo_attributes ? true : false

        is_private_label = (brand =~ /disco/i) ? false : true
        is_private_label = false if brand.nil? || brand&.empty?

        lat = nil
        long = nil

        attributes = []
        specs = product['specificationGroups'].select{|spec| spec['originalName'] == 'allSpecifications'}.first['specifications']

        specs = specs.reject{|spec| spec['originalName'] == 'sellerId'} if specs

        if specs && !specs.empty?
            specs.each do |sp|
                # attributes << "\"#{sp['name']}\": \"'#{sp['values'].first}'\""
                attributes << sp['name']
                attributes << sp['values'].first
            end
        end

        item_attributes = attributes.empty? ? nil : "{\"item attributes\":\"#{attributes.map{|a| "'#{a}'"}.join(",")}\"}"

        item_identifiers = (barcode.nil? || barcode&.empty?) ? nil : {barcode:"'#{barcode}'"}.to_json

        country_of_origin = nil #specs.select{|spec| spec['originalName'].include?('País de Origen')}.first['values'].first rescue nil

        outputs << {
            _collection: "items",
            _id: id,
            competitor_name: "DISCO",
            competitor_type: "dmart",
            store_name: "Disco Argentina",
            store_id: store_id,
            country_iso: "AR",
            language: "ENG",
            currency_code_lc: "ARS",
            scraped_at_timestamp: Time.now.strftime("%F %H:%M:%S"),
            competitor_product_id: id,
            name: name,
            brand: brand,
            category_id: category_id,
            category: category,
            sub_category: sub_category,
            customer_price_lc: customer_price_lc.to_s,
            base_price_lc: base_price_lc.to_s,
            has_discount: has_discount,
            discount_percentage: discount_percentage,
            rank_in_listing: idx,
            product_pieces: product_pieces,
            size_std: size_std,
            size_unit_std: size_unit_std,
            description: description,
            img_url: img_url,
            barcode: barcode,
            sku: id,
            url: url,
            is_available: is_available,
            crawled_source: "WEB",
            is_promoted: is_promoted,
            type_of_promotion: type_of_promotion,
            promo_attributes: promo_attributes,
            is_private_label: is_private_label,
            latitude: lat.to_s,
            longitude: long.to_s,
            reviews: nil,
            store_reviews: nil,
            item_attributes: item_attributes,
            item_identifiers: item_identifiers,
            page_number: page["vars"]["page_number"],
            country_of_origin: country_of_origin,
            variants: nil,
        }
        
    end

else
    raise 'dont use more filters: rank will be screwed up'
    # queue filter list if products count > 1000
    
    variables = '{"hideUnavailableItems":false,"behavior":"dynamic","categoryTreeBehavior":"default","query":"' + vars['params']['query'] + '","map":"' + vars['params']['map'] + '","selectedFacets":' + JSON.generate(vars['params']['selectedFacets']) + ',"initialAttributes":"' + vars['params']['map'] + '"}'
    # puts variables
    # exit!

    variables_encoded = Base64.strict_encode64(variables)
    # puts variables_encoded

    # NOTE: check the sha256Hash below if scraper fail
    url = Helpers::website + '/_v/segment/graphql/v1?appsEtag=remove&domain=store&extensions={"persistedQuery":{"version":1,"sha256Hash":"' + Sha256Hash::hash['facetsV2'] + '","sender":"vtex.store-resources@0.x","provider":"vtex.search-graphql@0.x"},"variables":"' + variables_encoded + '"}&locale=es-CO&maxAge=medium&operationName=facetsV2&variables={}&workspace=master'

    # puts url
    pages << {
        url: url,
        page_type: "more_filters",
        priority: 15,
        http2: true,
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
            categories: vars['categories'],
            category_id: page['vars']['category_id'],
            slug: vars['params']['query'],
            params: JSON.parse(variables),
            cookie: cookie,
        }
    }

end


