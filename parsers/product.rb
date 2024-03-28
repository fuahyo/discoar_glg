




if content.nil?
    if page['failed_response_status_code'] != 200
        if page['refetch_count'] < 2 
            refetch page['gid']
            finish
        else
            raise 'fail fetch' 
        end
    end
    
    html = Nokogiri::HTML(failed_content)
else 
    html = Nokogiri::HTML(content)
end

vars = page['vars']

product = vars['product']

# promo_text = html.at_css('div.pr0.items-stretch.vtex-flex-layout-0-x-stretchChildrenWidth.flex div.vtex-flex-layout-0-x-flexCol.vtex-flex-layout-0-x-flexCol--separator.vtex-flex-layout-0-x-flexCol--product-box.ml0.mr0.pl5.pr0.bl.bw1.flex.flex-column.h-100.w-100 div.vtex-flex-layout-0-x-flexColChild.vtex-flex-layout-0-x-flexColChild--separator.vtex-flex-layout-0-x-flexColChild--product-box.pb0 div.vtex-flex-layout-0-x-flexRow.vtex-flex-layout-0-x-flexRow--mainRow-price-box div.flex.mt0.mb0.pt0.pb0.justify-start.vtex-flex-layout-0-x-flexRowContent.vtex-flex-layout-0-x-flexRowContent--mainRow-price-box.items-stretch.w-100 div.pr0.items-stretch.vtex-flex-layout-0-x-stretchChildrenWidth.flex div.vtex-flex-layout-0-x-flexCol.vtex-flex-layout-0-x-flexCol--shelf-main-price-box.ml0.mr0.pl0.pr0.flex.flex-column.h-100.w-100 div.vtex-flex-layout-0-x-flexColChild.vtex-flex-layout-0-x-flexColChild--shelf-main-price-box.pb0 div.vtex-flex-layout-0-x-flexRow.vtex-flex-layout-0-x-flexRow--sellingPrice-discount div.flex.mt0.mb0.pt0.pb0.justify-start.vtex-flex-layout-0-x-flexRowContent.vtex-flex-layout-0-x-flexRowContent--sellingPrice-discount.items-stretch.w-100 div.pr0.items-stretch.vtex-flex-layout-0-x-stretchChildrenWidth.flex div[class*="discoargentina-store-theme"] div[class*="discoargentina-store-theme"] p')&.text&.strip



product['has_discount'] = false
product['discount_percentage'] = nil
product['type_of_promotion'] = nil
product['is_promoted'] = false
product['promo_attributes'] = nil
if product['base_price_lc'] != product['customer_price_lc']
    product['base_price_lc'] = product['customer_price_lc']
end

# take price from ¡Llevalos juntos! section since it has same price and able to show in our cache
slug = page['url'].gsub("https://www.disco.com.ar", "").strip
price_container = html.css('a').find{|s| s['href'] == slug}.css('div[class*="discoargentina-store-theme"]') rescue []
all_price = []
price_container.each do |s|
    all_price << s.text if s.text !~ /[a-zA-Z]/
end

all_price.uniq!

if all_price.size > 1
    product['customer_price_lc'] = all_price.min.gsub(/[$.]/, "").gsub(",", ".").to_f
    product['base_price_lc'] = all_price.max.gsub(/[$.]/, "").gsub(",", ".").to_f
    discount = (((product['base_price_lc'].to_f - product['customer_price_lc'].to_f)/product['base_price_lc'].to_f)*100).to_f.round(7)
    product['discount_percentage'] = discount
    product['has_discount'] = true
end

# if !promo_text.nil? && !promo_text&.empty?
#     product['is_promoted'] = true
#     product['type_of_promotion'] = 'Banner'
#     promo_detail = [promo_text]
#     product['promo_attributes'] = {promo_detail: "#{promo_detail.map{|t| "'#{t}'"}.join(', ')}"}.to_json

#     if promo_text&.include?('%') && promo_text =~ /^[\-\d\s\%]+$/
#         # product['discount_percentage'] = promo_text.gsub(/\%|\-/, '').to_f
#         # product['base_price_lc'] = (product['base_price_lc'].to_f * 1/(1 - (product['discount_percentage'] / 100))).to_f.round(1).to_s
#         # product['customer_price_lc'] = (product['base_price_lc'].to_f * (1 - (product['discount_percentage'] / 100))).to_f.ceil.to_s

#         product['customer_price_lc'] = Float(html.at('div.render-container.render-route-store-product div.render-provider div.vtex-store__template.bg-base div.flex.flex-column.min-vh-100.w-100 div.vtex-product-context-provider div.flex.flex-column.min-vh-100.w-100 div div.flex.flex-grow-1.w-100.flex-column div div.vtex-flex-layout-0-x-flexRow section.vtex-store-components-3-x-container.ph3.ph5-m.ph2-xl.mw9.center div.flex.mt4.mb7.pt7.pb7.justify-center.vtex-flex-layout-0-x-flexRowContent.items-stretch.w-100 div.pr0.items-stretch.vtex-flex-layout-0-x-stretchChildrenWidth.flex div.vtex-flex-layout-0-x-flexCol.vtex-flex-layout-0-x-flexCol--main-container.ml0.mr0.pl0.pr0.flex.flex-column.h-100.w-100 div.vtex-flex-layout-0-x-flexColChild.vtex-flex-layout-0-x-flexColChild--main-container.pb0 div.vtex-flex-layout-0-x-flexRow div.flex.mt0.mb0.pt0.pb0.justify-start.vtex-flex-layout-0-x-flexRowContent.items-stretch.w-100 div.pr0.items-stretch.vtex-flex-layout-0-x-stretchChildrenWidth.flex div.vtex-flex-layout-0-x-flexCol.vtex-flex-layout-0-x-flexCol--separator.vtex-flex-layout-0-x-flexCol--product-box.ml0.mr0.pl5.pr0.bl.bw1.flex.flex-column.h-100.w-100 div.vtex-flex-layout-0-x-flexColChild.vtex-flex-layout-0-x-flexColChild--separator.vtex-flex-layout-0-x-flexColChild--product-box.pb0 div.vtex-flex-layout-0-x-flexRow.vtex-flex-layout-0-x-flexRow--mainRow-price-box div.flex.mt0.mb0.pt0.pb0.justify-start.vtex-flex-layout-0-x-flexRowContent.vtex-flex-layout-0-x-flexRowContent--mainRow-price-box.items-stretch.w-100 div.pr0.items-stretch.vtex-flex-layout-0-x-stretchChildrenWidth.flex div.vtex-flex-layout-0-x-flexCol.vtex-flex-layout-0-x-flexCol--shelf-main-price-box.ml0.mr0.pl0.pr0.flex.flex-column.h-100.w-100 div.vtex-flex-layout-0-x-flexColChild.vtex-flex-layout-0-x-flexColChild--shelf-main-price-box.pb0 div.vtex-flex-layout-0-x-flexRow.vtex-flex-layout-0-x-flexRow--sellingPrice-discount div.flex.mt0.mb0.pt0.pb0.justify-start.vtex-flex-layout-0-x-flexRowContent.vtex-flex-layout-0-x-flexRowContent--sellingPrice-discount.items-stretch.w-100 div.pr0.items-stretch.vtex-flex-layout-0-x-stretchChildrenWidth.flex div.contenedor-precio span').text.gsub(/[^\d,]/, '').gsub(',', '.').to_f).to_s
        
#         if product['customer_price_lc'] == product['base_price_lc']
#             product['discount_percentage'] = promo_text.gsub(/\%|\-/, '').to_f  
#             product['customer_price_lc'] = (product['base_price_lc'].to_f * (1 - (product['discount_percentage'] / 100))).to_f.round(2).to_s
#         end

#         discount = (((product['base_price_lc'].to_f - product['customer_price_lc'].to_f)/product['base_price_lc'].to_f)*100).to_f.round(7)

#         # if discount == 0.0
#         #     product['discount_percentage'] = nil
#         #     product['has_discount'] = false
#         # else
#         product['discount_percentage'] = discount
#         product['has_discount'] = true
#         # end
#     end
# end

product['description'] = product['description'].gsub(%r{</?[^>]+?>}, "")
product['language'] = 'SPA'
outputs << product







