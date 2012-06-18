module CSV
  class Writer
    attr_reader :reader

    COLUMNS = ['title', 'market_open_minute', 'market_close_minute',
      'interval', 'columns', 'data', 'timezone_offset']

    def initialize(reader)
      @reader = reader

      establish_connection
    end

    def write
      params = COLUMNS.inject({}) do |params, column_name|
        params[column_name] = reader.send(column_name.to_sym)
        params
      end

      # possible I will remove this model because we should save more than 1.5
      # GB to the redis.
      data = FinancialData.create(params)

      data.values = []
      while points = reader.get_financial_data do
        data.values.push(points)
      end
      data.save

      reader.close
    end

    private

    def establish_connection
      @connection = Ohm.connect(:host => Options.redis.host,
                                :port => Options.redis.port)
    end
  end
end

