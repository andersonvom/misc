#!/usr/bin/ruby

require 'rubygems'
require 'watir-webdriver'
require 'yaml'

class Mint

  # Creates a new Browser window and logs into Mint.com
  #  - login_info: { :username => 'user', :password => 'passwd' }
  def initialize( login_info )
    @@config  = YAML.load_file("mint.yml")[:mint] # TODO: load configurarion on class load and not for every new object
    @browser  = Watir::Browser.new
    @username = login_info[:username]
    @password = login_info[:password]
    login
  end

  # Waits a little before allowing another request to go through
  # There is a better way of waiting for page elements to load, but they don't
  # exactly play well with AJAX
  def delay( seconds = nil )
    sleep ( seconds || @@config[:delay] )
  end

  # Logs into Mint.com with username and password provided on creation
  def login( login_info = {} )
    if @username
      @browser.goto @@config[:login_url]
    else
      raise "Username cannot be nil"
    end

    @browser.text_field(:id => @@config[:username_field]).set @username
    @browser.text_field(:id => @@config[:password_field]).set @password
    @browser.button(:value => @@config[:login_button]).click
    Watir::Wait.until { @browser.div( :class => @@config[:ready_condition] ).exists? }

    @username
  end

  # Adds a new transaction to Mint.com. The amount of the transaction is mandatory,
  # other validations are needed as well. A transaction has the following format:
  # transaction: { :date        => '1/1/2011',
  #                :description => 'lorem ipsum dolor sit amet',
  #                :category    => 'mint-category',
  #                :amount      => +/-99,
  #                :note        => 'lorem ipsum dolor sit amet' }
  # If the category doesn't exist, a default will be added (@@config[:categories][:unknown])
  def add_transaction( transaction )
    return nil if transaction[:amount] == 0

    # redirects to correct page in case browser is in a different page
    unless @browser.url.include? @@config[:transactions_url]
      @browser.goto @@config[:transactions_url]
      Watir::Wait.until { @browser.div( :class => @@config[:transaction][:ready_condition] ).exists? }
    end
    @browser.link(:id => @@config[:transaction][:add_link]).click

    # prevents errors from ocurring when the category doesn't exist.
    unless @@config[:categories][:valid].include? transaction[:category]
      transaction[:category] = @@config[:categories][:unknown]
    end

    # fill the form
    %w(date description amount note category).each do |field|
      field_id = { :id => @@config[:transaction][ "#{field}_field".to_sym ] }
      raise "Wrong field insertion" unless @browser.text_field( field_id ).text.empty?
      @browser.text_field( field_id ).set transaction[field.to_sym]
    end

    @browser.radio( :id => @@config[:transaction][:type_income] ).set if transaction[:amount] > 0
    @browser.checkbox( :id => @@config[:transaction][:deduct_last_field] ).clear
    @browser.link( :id => @@config[:transaction][:submit] ).click
    
    # TODO: Find out a way of waiting for this element to reload
    Watir::Wait.until { @browser.link( :id => 'controls-add', :class => 'button' ).exists? }
    delay

    transaction
  end

end

