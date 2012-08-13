require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require './config.rb'

trip_date = "08-16-2012"
num_tickets = 2

if ARGV.size != 2
  puts "Usage: ruby find_tickets.rb <mm-dd-yyyy> <num_tickets>"
  exit
else
  trip_date, num_tickets = ARGV
end

date = Date.strptime trip_date, "%m-%d-%Y"
url = "https://www.alcatrazcruises.com/SearchEventDaySpan.aspx?date=#{trip_date}&qty=#{num_tickets}"
doc = Nokogiri::HTML(open(url))
cells = doc.css("//table/tr/td").to_a
cells.shift 6 # remove headers
available_tickets = []
cells.each_with_index.collect do |cell, index|
  next if index % 6 == 0

  if cell.text != '-'
    column = (index % 6) - 1
    available_tickets << "#{date+column} at #{cell.text}"
  end
end

# Send email with ticket information
if available_tickets.empty?
  puts "No tickets available for the week of #{date}"
else

  puts "Tickets found! Sending email..."
  Mail.deliver do
         to RECIPIENT
       from FROM
    subject SUBJECT
       body available_tickets.join "\n"
  end
  puts 'DONE! \o/'

end

