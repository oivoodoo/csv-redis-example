require 'time'

module Csv
  class NasdaqBuilder
    attr_reader :files_path, :output_path

    EXTENSION = '.csv'
    NASDAQ_CSV = 'nasdaq'
    DELIMETER = ','
    COLUMNS = [
      'date', 'time', 'open', 'high', 'low', 'close', 'volume'
    ]
    WINDOW_SIZE = 59

    def initialize(files_path, output_path)
      @marker = 0
      @files_path = files_path + "*" + EXTENSION
      @output_path = File.join(output_path, NASDAQ_CSV + EXTENSION)
      @lines ||= File.readlines(tables.first)
    end

    def generate
      File.open(output_path, "w") do |writer|
        build_headers(writer)

        date, time = "date", "time"

        until (date.nil? or date.empty?) and (time.nil? or time.empty?) do
          date, time = get_random_date

          unless date.nil? or time.nil?
            lines = tables.map do |file|
              find(file, date, time)
            end.compact

            writer.write(([date, time] + lines).flatten.join(DELIMETER) + "\n")
          end
        end
      end
    end

    private

    def get_random_date
      return if @lines.size <= @marker + WINDOW_SIZE

      @marker, line = @marker + rand(0..WINDOW_SIZE), @lines[@marker]

      cells = line.split(/#{DELIMETER}/)

      cells[0..1]
    end

    def build_headers(writer)
      headers = COLUMNS.map do |column|
        components.map do |table|
          header_name(column, table)
        end
      end.flatten.join(DELIMETER)

      writer.write(headers + "\n")
    end

    def header_name(column, table)
      "#{table}_#{column}"
    end

    def find(file_name, date, time)
      return if date.nil? or time.nil?

      lines = File.readlines(file_name)
      lines = group_by_date(lines, date)
      line = lines.find do |line|
        cells = line.strip.split(/#{DELIMETER}/)

        (Time.parse("#{date} #{time}") - Time.parse("#{cells[0]} #{cells[1]}")).zero?
      end.to_s.strip

      unless line.empty?
        line.split(/#{DELIMETER}/)[2..COLUMNS.size].join(DELIMETER)
      end
    end

    def group_by_date(lines, date)
      lines.select do |line|
        cells = line.strip.split(/#{DELIMETER}/)

        if cells.size > 2
          diff = Date.parse(date) - Date.parse("#{cells[0]}")

          diff.to_f == 0.0
        end
      end
    end

    def components
      @components ||= tables.map do |file_name|
        normalize_table_name(file_name)
      end
    end

    def tables
      @tables ||= Dir[files_path]
    end

    def normalize_table_name(file_name)
      file_name = File.basename(file_name, EXTENSION)

      file_name.gsub(/table_/, '')
    end
  end
end

