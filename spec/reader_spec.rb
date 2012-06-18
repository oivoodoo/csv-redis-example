require 'spec_helper'

include CSV

describe Reader do
  let(:reader) { Reader.new('./spec/fixtures/prices.csv') }

  context "on load" do
    it "should read title" do
      reader.title.should == "EXCHANGE%3DNASDAQ"
    end

    it "should read market open minute" do
      reader.market_open_minute.should == 570
    end

    it "should read market close minute" do
      reader.market_close_minute.should == 960
    end

    it "should read interval" do
      reader.interval.should == 86400
    end

    it "should reader columns" do
      reader.columns.should == [
        "DATE", "CLOSE", "HIGH", "LOW", "OPEN", "VOLUME"
      ]
    end

    it "should read data column" do
      reader.data.should == ""
    end

    it "should read timezone offset" do
      reader.timezone_offset.should == -240
    end

    it "should read financial data" do
      reader.get_financial_data.should == [
        'a1337630400', '62.51', '62.57', '60.85', '60.92', '61471322'
      ]
      reader.get_financial_data.should == [
        '1', '62.44', '62.95', '61.989', '62.66', '62954723'
      ]
      reader.get_financial_data.should == [
        '2','62.56', '62.71', '61.37', '61.93', '56951072'
      ]
      reader.get_financial_data.should be_nil
    end

    it "should be possible to close file after reading" do
      reader.file.should_receive(:close)
      reader.close
    end
  end
end

