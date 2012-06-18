require 'spec_helper'

include CSV

describe Writer do
  let(:reader) { Reader.new('./spec/fixtures/prices.csv') }
  let(:writer) { Writer.new(reader) }

  context "on write" do
    before { writer.write }

    it "should create new data model" do
      FinancialData.all.should_not be_empty
    end

    it "should have right fields" do
      datas = FinancialData.all
      data = datas[datas.size - 1]
      data.title.should == reader.title
      data.values.should == "[[\"a1337630400\", \"62.51\", \"62.57\", \"60.85\", \"60.92\", \"61471322\"], [\"1\", \"62.44\", \"62.95\", \"61.989\", \"62.66\", \"62954723\"], [\"2\", \"62.56\", \"62.71\", \"61.37\", \"61.93\", \"56951072\"]]"
    end
  end
end

