require 'terminal-table'

@list_params = [:loyal, :wallets, :foreign, :uncollected, :incontrol]
@more_dimensions = @list_params - [:uncollected, :wallets]
@dimensions = [:c, :usd]

def dimension(all = false)
  result = Hash.new
  result[@dimensions[0]] = 0
  return result unless all
  @dimensions.each{|d| result[d] = 0 }
  return result
end

def template()
  result = Hash.new
  @list_params.each do |p|
    #puts "#{@more_dimensions.inspect}\t#{p}\t#{@more_dimensions.include? p}\t#{dimension( @more_dimensions.include? p ).inspect}"
    result.merge! Hash[p, dimension( @more_dimensions.include? p ) ]
    #puts "#{Hash[p, dimension( @more_dimensions.include? p ) ]}"
  end
  #puts result.inspect
  result
end

company_members = []
Member.all.each{|m| company_members << m.id if m.ref_member_id == 1}
coins = Hash.new
total = template()

Currency.select{|c| coins[c.id] = template() if c.type == "coin" && !( ['ceth','ytc'].include?(c.id.to_s) ) }
#puts coins.inspect
Account.all.each do |a|
  begin
#    puts "#{coins[a.currency_id].inspect} #{coins[a.currency_id][
#      ( company_members.include? a.member_id ) ? :loyal : :foreign][:c].inspect}"
    coins[a.currency_id][
      ( company_members.include? a.member_id ) ? :loyal : :foreign
    ][:c] += a.balance
  rescue
  end
end

def withdraw_wallets(currency)
  Wallet
    .active
    .withdraw
    .ordered
    .where(currency_id: currency)
end

coins.each do |c,v|
#  puts "#{c&.inspect}\t--\t#{v&.inspect}"
  exclude_addresses_from_uncollected = []
  currency = Currency.find(c)
  blockchain_client = BlockchainClient[currency.blockchain.key]
  withdraw_wallets(c).each do |wallet|
#    blockchain_client = BlockchainClient[Blockchain.find_by_key(wallet.blockchain_key).key]
    wallet_balance = blockchain_client.load_balance!(wallet.address, currency)
    exclude_addresses_from_uncollected.push wallet.address
#    puts "\n#{c.upcase} wallet #{wallet.address}"
#    puts "\tbalance #{wallet_balance}"
#    puts "\trunning total #{v[:wallets][:c]}\n"
    v[:wallets][:c] += [ wallet_balance.to_f - (c == "xrp" ? 20 : 0).to_f, 0].max
    #puts "#{c.upcase} wallet #{wallet.address}\n\tbalance #{wallet_balance}\n\trunning total #{v[:wallets][:c]}\n"
    #puts "#{blockchain_client.inspect}\n#{wallet.inspect}\n\n" if c == "btc"
  end
#  blockchain_client = BlockchainClient[currency.blockchain.key]
  if (
      blockchain_client.class.ancestors.include? BlockchainClient::Bitcoin and not
      [
        BlockchainClient::Reecore,
        BlockchainClient::Ripple,
      ].any? {|client| blockchain_client.class.ancestors.include? client }
    )
    v[:uncollected][:c] = blockchain_client.load_balance!("", currency, {minimumAmount:"0.00005"}, exclude_addresses_from_uncollected)
    v[:incontrol][:c] =
      v[:wallets][:c] +
      v[:uncollected][:c] -
      v[:foreign][:c]
  else
    if blockchain_client.class.ancestors.include? BlockchainClient::Ethereum
      Account.all.each do |a|
#        puts "#{a.payment_addresses&.first&.address} #{currency.id}" if  a.currency_id == c
        a.payment_addresses.all.each do |w|
          v[:uncollected][:c] +=
          blockchain_client.load_balance!(
            w.address, currency) unless w.address.blank?
        end if a.currency_id == c
      end
    elsif blockchain_client.class.ancestors.include? BlockchainClient::Ripple
    elsif blockchain_client.class.ancestors.include? BlockchainClient::Reecore
      v[:uncollected][:c] = blockchain_client.load_balance!("", currency) #, {minimumAmount:"0.00005"}, exclude_addresses_from_uncollected)
      v[:incontrol][:c] =
        v[:wallets][:c] +
        v[:uncollected][:c] -
        v[:foreign][:c]
    else
      v[:uncollected][:c] = nil
    end
    v[:incontrol][:c] =
      v[:wallets][:c] +
      ( v[:uncollected][:c].present? ? v[:uncollected][:c] : 0 ) -
      v[:foreign][:c]
  end
end


#puts coins.inspect
table = Terminal::Table.new :headings => ['Coin name',
    "Loyal members\n- - - - - - - - - - -\nCentral Wallets total\n- - - - - - - - - - -\nUncollected Wallets total",
    "Foreign users\ntotal balance",
    "In control of\nour team (take\nnote of n/a\nuncollected data)"]
table.style = {:all_separators => true}
@market_afcash_estimator = nil
@afcash_price = nil
coins.each do |c,v|
  [:loyal, :foreign, :incontrol].each do |p|
#    puts "#{c.inspect} #{v[p][:c]} * #{Currency.find(c)&.price&.to_f} = #{v[p][:c] * Currency.find(c)&.price&.to_f}"
    if c != "afcash"
      begin
        v[p][:usd] =  v[p][:c] * Currency.find(c)&.price&.to_f if v[p][:c].present?
      rescue => e
        Currency.find(c)
        raise e
      end
    else
      @market_afcash_estimator = [
        Market.find("kitafcash"),
        Market.find("etaafcash"),
        Market.find("hotafcash"),
        Market.find("afcasheth"),
        Market.find("afcashusd"),
      ].max_by do |m,v|
        ( m.bid_unit == "afcash" ?
          Currency.find(m.ask_unit)&.price&.to_f :
          1
        ) * m.ticker[:volume]&.to_f
      end
      afcash_price = @market_afcash_estimator.yield_self do |m|
        ( m.bid_unit == "afcash" ?
          Currency.find(m.ask_unit)&.price&.to_f / m.ticker[:high]&.to_f :
          Currency.find(m.bid_unit)&.price&.to_f * m.ticker[:low]&.to_f
        )
      end
      v[p][:usd] = v[p][:c] * afcash_price if v[p][:c].present?
    end
    total[p][:usd] += v[p][:usd] if v[p][:usd].present?
  end
  table << [c.upcase,
    {:alignment => :right, :value =>
      "#{'%.8f' % v[:loyal    ][:c]}\n" \
      "#{'%.8f' % v[:wallets  ][:c]}\n" \
      "#{v[:uncollected ][:c].present? ? '%.8f' % v[:uncollected][:c] : """n/a      """}"},
    {:alignment => :right, :value =>
      "#{'%.8f' % v[:foreign  ][:c]}\n" \
      "#{v[:foreign  ][:usd].present? ? '$%.2f' % v[:foreign  ][:usd] : """n/a      """}"},
    {:alignment => :right, :value =>
      "#{'%.8f' % v[:incontrol][:c]}\n" \
      "#{v[:incontrol][:usd].present? ? '$%.2f' % v[:incontrol][:usd] : """n/a      """}"}
  ]
end

puts
puts table
puts "\n\n\tTotal foreign surplus: " \
  "#{ ( total[:foreign  ][:usd].present? ) ? ( '$%.2f' % total[:foreign  ][:usd] ) : 'n/a'}\n\t" \
  "Total under our team's control: " \
  "#{ ( total[:incontrol][:usd].present? ) ? ( '$%.2f' % total[:incontrol][:usd] ) : 'n/a'}\n\n" \
  "Note.\tAFCASH price is estimated from top volume market #{@market_afcash_estimator.ask_unit.upcase}/" \
  "#{@market_afcash_estimator.bid_unit.upcase}:\n\n\t24h volume: $" \
  "#{'%.2f' % @market_afcash_estimator.yield_self{|m| ( m.bid_unit == 'afcash' ? Currency.find(m.ask_unit)&.price&.to_f * m.ticker[:volume]&.to_f : Currency.find(m.bid_unit)&.price&.to_f * m.ticker[:low]&.to_f * m.ticker[:volume]&.to_f  ) }}\n\t" \
  "#{ ( @market_afcash_estimator.bid_unit == 'afcash' ? @market_afcash_estimator.ask_unit.upcase : @market_afcash_estimator.bid_unit.upcase ) } price: $" \
  "#{'%.8f' % @market_afcash_estimator.yield_self{|m| ( m.bid_unit == 'afcash' ? Currency.find(m.ask_unit)&.price&.to_f : Currency.find(m.bid_unit)&.price&.to_f  ) }}\n\t" \
  "Estimated AFCASH price: $" \
  "#{'%.8f' % @market_afcash_estimator.yield_self{|m| ( m.bid_unit == "afcash" ? Currency.find(m.ask_unit)&.price&.to_f / m.ticker[:high]&.to_f : Currency.find(m.bid_unit)&.price&.to_f * m.ticker[:low]&.to_f ) }}\n\n" unless
  @market_afcash_estimator.blank?
