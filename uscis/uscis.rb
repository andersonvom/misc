require 'nokogiri'
require 'open-uri'

# Reader for USCIS H1-B cap_count page to keep track of the number of approved/pending H1-B petitions
class USCIS
  attr_accessor :page, :logfile, :logger

  URL = 'http://www.uscis.gov/h-1b_count'
  LOGFILE = File.dirname(__FILE__) + '/cap_count.csv'

  # Reads USCIS cap_count page and opens the logfile
  def initialize
    self.page = Nokogiri::HTML(open(URL))
    self.logfile = open LOGFILE, 'a+'
  end

  # Returns the current number of approved/pending petitions
  def count
    page.at_xpath("//table[@class='MsoNormalTable']/tbody/tr/td[3]/p").inner_html
  end

  # Returns the date of the last count of approved/pending petitions
  def date
    page.at_xpath("//table[@class='MsoNormalTable']/tbody/tr/td[4]/p").inner_html
  end

  # Writes the last date and count of approved/pending petitions to logfile if it changed
  def log
    last_line = logfile.lines.to_a.last || ""
    last_entry = last_line.split(/\s/)
    new_entry = "#{date}\t#{count}\n"
    if last_entry.first != date
      logfile.write new_entry
      logfile.flush
    end
    puts new_entry
  end

end

# Automatically runs logger if called directly
if __FILE__ == $0
  uscis = USCIS.new
  uscis.log
end
