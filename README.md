# Introduction
Fast and easy way to get all data about all coins in any fiat value.
Get data for analysis or use it to make a brand new crypto app.
After scrapping prices in CSV file, and printing colorized output,
you can access each rate with `#price(coin)`. No configuration, just run.

 - Collect prices of defined coins from _cryptocompare.com_
 - Save data into object
 - Save to CSV and print colorized output
 - Print-only without saving
 - Save-only without printing  

# How to install

Make sure you have ruby and git installed:

```bash
 # download repo and install dependencies like colorize and rest-client
 git clone https://github.com/decentralizuj/crates.git
 cd crates
 bundle install
```  

# How to run

If you want to edit default coins:

```ruby
 # open 'bin/crates' and edit line(5):
 > (5): COINS = %w[ ... ].freeze
```  

Run from terminal:

```ruby
 # add fiat currencies as arguments
 # also accept `--no-save` and `--no-print` as args

 $ ruby bin/crates usd eur rsd
 $ ruby bin/crates usd eur rsd --no-save
 $ ruby bin/crates usd eur rsd --no-print
```    

# How to use

Initialize new object with your own configuration. If you want to use defaults:

```ruby
 # you can edit this in 'bin/crates'

 - #coins: [BTC, LTC, XMR, ETH, BCH, ZEC]
 - #save:  true  
 - #print: true 
```  

Otherwise, #new accept 'currency' as argument, and an 'options hash':  

```ruby
 - first parameter is currency, defauilt is 'EUR'
 - other accepted options are:  
     print: boolean
     save:  boolean
     coins: array
```  

Example:

```ruby
 # configure default values

 COINS = %w[ BTC XMR LTC ETH ZEC ].freeze
 PRINT = true
 SAVE  = true

 # create new object

 @rates = C::Rates.new( :eur, coins: COINS, print: PRINT, save: SAVE )

 # make single request

 @rates.get
 
 # C::Rates#get accept same args as #new, but do not change default values

 CURRENCIES = %w[ USD EUR RSD ].freeze

 CURRENCIES.each do |currency|
   @rates.get currency
  end
```  

This will print/save data as configured, while making prices easily
accessible with Rates#price(:symbol).

```ruby
 # Getter method with all coins and values 

 @rates.prices
 # => { "BTC"=>48867.67, "XMR"=>200.31, "LTC"=>164.37 }
 # => Accessible with @rates['BTC']


 # Get price for each coin
 # C::Rates#price(:coin)

 @rates.price(:btc)      # accept symbol
 # => 48867.67

 @rates.price('xmr')     # or string
 # => 200.31
```  

C::Rates has two setter methods:

```ruby
 @rates.currency = 'EUR'

 @rates.coins = %w[BTC XMR LTC]
```  

Other available objects are:

```ruby
 # After new object is initialized, you can use:

 @rates.currency
 # => "EUR"

 @rates.coins
 # => "BTC, XMR, LTC"

 @rates.save?
 # => save output -> (true/false)

 @rates.print?
 # => print output -> (true/false)

 @rates.count
 # => 0 -> (number of fail requests)

 # After you call Rates#get:

 @rates.url
 # => constructed URL

 @rates.reponse
 # => response from RestClient.get (accept #code, #headers, #body)

 @rates.data
 # => JSON parsed object will all data about all coins

 @rates.table
 # => path to saved CSV file
 # => file is named CURRENCY_rates.csv (eur_rates.csv)
```  

# TO-DO

This gem is start of app that I am working on to help me with auto-trades.
At the moment I use it to notify me when price change more then 2% from last trade.
Then I perform crypto-to-crypto trade, and wait for price to change again.
To make it reliable and worth of using, plan is to add next functions:

 - add more sources to get data from them
 - scrap more data into tables (only data I need)
 - add support for API-KEYS
 - rotate sources if requests are sent too often
 - add support for proxy and headers rotation
 - create charts from prices at given time (each 10min etc)
 - create GIF animation from charts per time (each 30 min etc)
