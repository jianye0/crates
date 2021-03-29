![GIF](crates.gif)

# C-Rates

 - Collect prices of defined coins 
 - Save to CSV and print colorized output
 - Print-only without saving
 - Save-only without printing

# How to use

Run from terminal:

```ruby
ruby crates.rb usd eur rsd
ruby crates.rb usd eur rsd --no-save
ruby crates.rb usd eur rsd --no-print
```    

Use in your own project:

```ruby
# Self method as shortcut

C::Rates.get! :eur, coins: %w[BTC XMR LTC], save: false


# Define your data on new object

@rates = C::Rates.new :eur, print: false

@rates.get

 > @rates.coins
    # => defined coins
 > @rates.currency
    # => defined currency
 > @rates.url
    # => constructed URL
 > @rates.response
    # => rest-client response
 > @rates.table
    # => path/to/eur_rates.csv
 > @rates.data
    # => all prices as array
 > @rates.prices
    # => all coins and prices as hash
 > @rates.price(:btc)
    # => get price for coin
```
