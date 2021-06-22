prices_scrap = Faraday.get 'https://afcash.app/rules/rules.json'
data = JSON.parse(prices_scrap.body)
#puts data.inspect
data.each do |base, quote|
  next if base == 'afcash'
  next if !Currency.exists?(base)
  next if quote['afcash'].nil?
  next if !(quote['afcash']['operator'] == '<=')
  next if !(quote['afcash']['parameter'] == 'price')
  value = quote['afcash']['value'].to_f == 0 ? '%.8f' % ( 1 / data['afcash'][base]['value'].to_f ) : quote['afcash']['value']
  puts "#{base} assigned #{value}"
  Currency.find(base).update(price: value)
  Currency.find(base).build_options_schema
  Currency.find(base).update upstream_downscale: '%0.8f' % ( 1 / value.to_f )
end
