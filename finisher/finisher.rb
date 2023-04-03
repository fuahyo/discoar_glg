per_page = 500
last_id = ''
locations = []

while true
  query = {
    '_id' => {'$gt' => last_id},
    '$orderby' => [{'_id' => 1}]
  }
  records = find_outputs('available_products', query, 1, per_page)

#   require 'byebug'
#   byebug
  records.each do |product|
    if product['name'].include? 'Un'
      product_pieces_regex = [
        /(\d+)\s?Un(?!\S)/i,
        /(\d+)\s?Unidades(?!\S)/i,
      ].find {|ppr| product['name'] =~ ppr}
      product['product_pieces'] = product_pieces_regex ? $1.to_i : 1
      # product['size_unit_std']
      outputs << product

      save_outputs(outputs) if outputs.count > 99
    end
  end

  break if records.nil? || records.count < 1

  last_id = records.last['_id']
end

# save_outputs(outputs)