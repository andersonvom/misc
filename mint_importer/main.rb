#!/usr/bin/ruby

require 'csv'
require 'yaml'
require 'mint.rb'

login_info = YAML::load_file('login.yml')[:mint]
mint = Mint.new login_info

# Adapt the following section to adequate CSV format
CSV_FILE='transactions.csv'
CSV.foreach CSV_FILE do |row|
  transaction = {}
  transaction[:date]        = row[0].to_s.strip
  transaction[:description] = row[2].to_s.strip
  transaction[:category]    = row[3].to_s.strip
  transaction[:amount]      = row[4].to_f
  transaction[:note]        = 'Imported from Finance Works'

  mint.add_transaction transaction if transaction[:amount].to_s != 0.to_f.to_s 
end

