require 'ohm'

module CSV
  class FinancialData< Ohm::Model
    attribute :title
    attribute :market_open_minute
    attribute :market_close_minute
    attribute :interval
    attribute :data
    attribute :timezone_offset
    attribute :columns
    attribute :values
  end
end
