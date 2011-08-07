module Docketeer
  class Logger
    attr_accessor :path

    # Create a new log file if one doesn't already exist.
    # returns the log file to the class
    def initialize(path)
      @path = File.expand_path(path)
      log = File.new(@path, 'a+')
    end

    # Add an entry to the log file
    # and return the message back to
    # the class
    def add(message)
      File.open(self.path, "a+") do |file|
        file.puts(message)
      end
      return message
    end

    # Read the last line of the log file
    def last
      File.open(self.path, 'a+') do |file|
        line = file.readlines.last
        {
          :id => line[0..4],
          :year_prefix => line[0..1],
          :docket_id => line[2..4]
        }
      end
    end

    # Generate the next docket number
    def next
      current_year_prefix = Time.now.strftime("%y")
      number = "#{ current_year_prefix }001"
      if self.last[:year_prefix] == current_year_prefix
        number = (self.last[:id].to_i + 1).to_s
      end
      return number
    end

  end
end
