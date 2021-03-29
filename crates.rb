#!/usr/bin/env ruby
require 'json'
require 'csv'
require 'colorize'
require 'rest-client'

  # @rates = C::Rates.new :eur, coins: %w[BTC XMR LTC], print: false
  #  > @rates.get
  #  > @rates.get :usd, coins: ['DASH', 'BCH'], save: false

  # C::Rates.get! :eur, coins: ['DASH', 'BCH'], print: false

module C
  
  # define coins to scrap
  COINS = %w[ BTC XMR LTC ETH BCH ZEC ].freeze
  # max number of retries
  RPT = 3
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
      @currency = currency.to_s.upcase unless currency.nil?
      @table = @currency.to_s.downcase  + '_rates.csv'
      @count = 0
      execute_request(opts[:coins])
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

    def execute_request( coins = [] )
      @prices, @data_array, coin_uri = {}, [], ''
      coins.collect { |coin| coin_uri << "fsyms=#{coin.to_s}&" }
      @url = URL + "#{coin_uri}tsyms=#{@currency}"
      @response = RestClient.get @url
      @data = JSON.parse @response
      print_terminal_header if print?
      @data_array << Time.now.to_s
      coins.each do |coin|
        @data_array << value = @data["RAW"][coin][@currency]["PRICE"].round(2)
        @prices[coin] = value
        puts "[".yellow.bold + "#{coin}".green.bold + "]".yellow.bold + ": #{value}".bold if print?
      end
      puts if print?
      save_csv_output!(coins) if save?
     rescue
      @count += 1
      if @count < RPT
        puts " > Request No".red + "[".green + @count.to_s.yellow + "]".green + " faild".red if print?
      else
        puts "[".green.bold + "EXIT!".red.bold + "]".green.bold + " too many faild requests".red if print?
        exit 1
      end
      execute_request coins, opts
    end
 
    def print_terminal_header
      30.times { print '='.green } and puts
      puts "[".green + @currency.to_s.yellow.bold + "]".green + " conversion rate"
      30.times { print '='.green } and puts 
    end
  
    def save_csv_output!( coins = nil )
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

  if ARGV.include?('-h') or ARGV.include?('--help')
    puts "\n Enter fiat currencies as arguments:\n".yellow
    puts "  $ ruby crates.rb usd eur rsd".green
    puts "  $ ruby crates.rb usd eur rsd --no-save".green
    puts "  $ ruby crates.rb usd eur rsd --no-print\n".green
    exit 1
  else
    ARGV.include?('--no-save') ? ns = false : ns = true
    ARGV.include?('--no-print') ? np = false : np = true
    @rates = C::Rates.new(:eur, save: ns, print: np)
  end
  
  unless ARGV.empty?
    ARGV.each do |fiat|
      next if %w[--no-print --no-save].include?(fiat.to_s.downcase)
      @rates.get fiat
    end
  else
    @rates.get
  end
