require 'json'
require 'csv'
require 'colorize'
require 'rest-client'

module C
  
  # set default coins
  COINS = %w[ BTC XMR LTC ETH BCH ZEC ].freeze
  # max number of retries
  MAX_RETRY = 3
  # api base-url
  URL = 'https://min-api.cryptocompare.com/data/pricemultifull?'.freeze

  class Rates

    attr_reader   :response, :data, :url, :table, :count, :prices
    attr_accessor :currency, :coins

    def self.get!( currency = :eur, opts = {} )
      @rates = Rates.new currency, opts
      @rates.get
    end

    def initialize( currency = :eur, opts = {} )
      @save  = opts[:save ].nil? ? true : opts[:save]
      @print = opts[:print].nil? ? true : opts[:print]
      @coins = opts[:coins].nil? ? COINS : Array(opts[:coins])
      @currency = currency.to_s.upcase
    end

    def get( currency = nil, opts = {} )
      @save  = opts[:save]  unless opts[:save].nil?
      @print = opts[:print] unless opts[:print].nil?
      opts[:coins] ||= @coins
      currency     ||= @currency
      @table = currency.to_s.downcase  + '_rates.csv'
      @count = 0
      execute_request(opts[:coins], currency)
    end

    def price( coin )
      @prices[coin.to_s.upcase]
    end

    def save?
      @save == true
    end

    def print?
      @print == true
    end

    private

    def execute_request( coins = @coins, currency = @currency )
      @prices, @data_array, coin_uri = {}, [], ''
      coins.collect { |coin| coin_uri << "fsyms=#{coin}&" }
      @url = URL + "#{coin_uri}tsyms=#{currency}"
      @response = RestClient.get @url
      @data = JSON.parse @response
      @data_array << Time.now.to_s
      coins.each do |coin|
        @data_array << value = @data["RAW"][coin.to_s.upcase][currency.to_s.upcase]["PRICE"].round(2)
        @prices[coin] = value
      end
      print_data_for(currency) if print?
      save_data(coins) if save?
     rescue
      @count += 1
      if @count >= MAX_RETRY
        puts @response.to_s.split(',')
        exit 1
      else
        execute_request(coins, currency)
      end
    end

    def print_data_for( currency )
      30.times { print '='.green } and puts
      puts "[".green + currency.to_s.upcase.yellow.bold + "]".green + " conversion rate"
      30.times { print '='.green } and puts
      @prices.each do |name, value|
        print "[".yellow.bold + "#{name}".green.bold + "]".yellow.bold
        puts ": #{value}".bold
      end
    end
  
    def save_data( coins = nil )
      coins ||= @coins
      create_csv_headers(coins) unless File.exist?(@table)
      CSV.open(@table, 'ab') { |column| column << @data_array }
    end

    def create_csv_headers( coins = [] )
      header_array = ['TIME']
      coins.each { |coin| header_array << coin }
      CSV.open(@table, "w" ) { |header| header << header_array }
    end
  end
end
