require 'spec_helper'

include CSV

describe Options do
  it { Options.redis.host.should == "localhost" }
  it { Options.redis.port.should == 6379 }
end
