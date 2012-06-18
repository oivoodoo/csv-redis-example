require 'simple-conf'
require 'ostruct'

module CSV
  class Options
    include SimpleConf

    def self.redis
      @redis ||= OpenStruct.new(production.redis)
    end
  end
end
