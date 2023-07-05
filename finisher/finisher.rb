per_page = 500
last_id = ''
locations = []

while true
  query = {
    '_id' => {'$gt' => last_id},
    '$orderby' => [{'_id' => 1}]
  }
  records = find_outputs('items', query, 1, per_page)

#   require 'byebug'
#   byebug
  records.each do |product|
    product['country_iso'] = 'UY'
    product['currency_code_lc'] = 'UYU'
    product['store_name'] = 'Disco Uruguay'
    product['language'] = 'SPA'
    product['barcode'] = product['competitor_product_id']
    if product['page_number'].nil?
      product['page_number'] = 1
    end
    outputs << product
    save_outputs(outputs) if outputs.count > 99
  end

  break if records.nil? || records.count < 1

  last_id = records.last['_id']
end

# save_outputs(outputs)