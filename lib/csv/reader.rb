require 'delegate'

module CSV
  class Reader < SimpleDelegator
    attr_reader :title, :market_open_minute, :market_close_minute, :interval,
      :columns, :data, :timezone_offset

    attr_reader :file

    def initialize(filename)
      load_file filename
    end

    def get_financial_data
      data = readline.split(',')

      return if @file.eof? or data.empty?
      data
    end

    def __getobj__
      file
    end

    private

    def load_file(filename)
      @file = File.open(filename, 'r')

      @title = readline
      @market_open_minute = readline.gsub(/MARKET_OPEN_MINUTE=/,'').to_i
      @market_close_minute = readline.gsub(/MARKET_CLOSE_MINUTE=/,'').to_i
      @interval = readline.gsub(/INTERVAL=/,'').to_i
      @columns = readline.gsub(/COLUMNS=/,'').split(/,/)
      @data = readline.gsub(/DATA=/,'')
      @timezone_offset = readline.gsub(/TIMEZONE_OFFSET=/,'').to_i
    end

    def readline
      file.readline.strip
    end
  end
end
