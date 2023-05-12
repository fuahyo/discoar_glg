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
    if product['page_number'].nil?
      product['page_number'] = 1
      outputs << product

      save_outputs(outputs) if outputs.count > 99
    end
  end

  break if records.nil? || records.count < 1

  last_id = records.last['_id']
end

# save_outputs(outputs)