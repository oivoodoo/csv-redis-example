require 'spec_helper'

include Csv

describe NasdaqBuilder do
  let(:builder) { NasdaqBuilder.new('./spec/fixtures/nasdaq/', './tmp/') }

  before do
    NasdaqBuilder.const_set(:WINDOW_SIZE, 1)
    
    builder.generate
  end

  it "should generate nasdaq csv file" do
    File.exists?(builder.output_path).should be
  end

  it "should write headers into nasdaq csv file" do
    content = File.read(builder.output_path)

    ["file1", "file2"].each do |file_name|
      NasdaqBuilder::COLUMNS.each do |column|
        content.should include("#{file_name}_#{column}")
      end
    end
  end

  it "should pick up random line with data" do
    content = File.read(builder.output_path)

    content.should include("20120607,1626,57.695,57.695,57.695,57.695,400")
  end
end

