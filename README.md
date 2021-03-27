# c-rates

 - Collect prices of defined coins to CSV table  
 - Print colorized output

# how-to  
```ruby
ruby crates.rb usd eur rsd
```  
or
```ruby
C::Rates.get! :eur, coins: %w[BTC XMR LTC], save: false

@rates = C::Rates.new :eur, print: false
@rates.get
 > @rates.coins
 > @rates.url
 > @rates.currency
 > @rates.table
 > @rates.prices
 > @rates.price(:btc)
```
