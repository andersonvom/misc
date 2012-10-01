#!/usr/bin/ruby

# Merges contents of `origin` directory into `destination`.
# A given file `F` inside `origin` will be:
# - Removed if an exact copy exists in `destination`
# - Copied into `destination` if it does not yet exist
# - Left alone if it exists in both directories but its content differs
module FSUtils

  class Merge

    attr_accessor :files, :origin, :destination

    def initialize(origin, destination)
      self.origin = origin
      self.destination = destination
      self.files = []
      puts "Analyzing '#{origin}' and '#{destination}'..."
      info = `diff --ignore-file-name-case -qsr "#{origin}" "#{destination}"`.split "\n"
      info.each do |item|
        file = {}
        match_info = item.match /(Files (.*) and (.*) (are (identical)|(differ)))|(Only in #{origin}: (.*))/

        if match_info
          unless match_info[2].nil?
            file[:name] = match_info[2]
            file[:status] = (match_info[5] or match_info[6]).to_sym
          else
            file[:name] = match_info[8]
            file[:status] = :only_left
          end
        end
        self.files << file unless file.empty?
      end
    end

    def run
      identical.each { |file| `rm "#{file[:name]}"` }
      only_left.each { |file| `mv "#{origin}/#{file[:name]}" "#{destination}"` }
      puts "#{different.count} files were left untouched because they are different:"
      puts different.collect { |file| file[:name] }.join ", "
    end

    def simulate
      puts "The following #{identical.count} files will be REMOVED from #{origin}:"
      identical.each { |file| puts "\t#{file[:name]}" }
      puts

      puts "The following #{only_left.count} files will be COPIED to #{destination}:"
      only_left.each { |file| puts "\t#{origin}/#{file[:name]}" }
      puts

      puts "The following #{different.count} files will be left untouched because they are DIFFERENT:"
      different.collect { |file| puts "\t#{file[:name]}" }
      puts
    end

    def identical
      files.collect { |f| f if f[:status] == :identical }.compact
    end

    def different
      files.collect { |f| f if f[:status] == :differ }.compact
    end

    def only_left
      files.collect { |f| f if f[:status] == :only_left }.compact
    end

    def only_right
      files.collect { |f| f if f[:status] == :only_right }.compact
    end

  end

end

if $0 == __FILE__
  origin = ARGV[0]
  destination = ARGV[1]

  if origin.to_s.empty? or destination.to_s.empty?
    puts "Usage: #{$0} <origin_folder> <destination_folder>"
    exit 1
  end

  merge = FSUtils::Merge.new origin, destination
  merge.simulate
  puts "Proceed with merge (y/N)?"
  if STDIN.gets.chomp =~ /^y$/i
    merge.run
  else
    puts "Exiting..."
  end
  exit
end

