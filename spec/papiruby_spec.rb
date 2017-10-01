require "spec_helper"

RSpec.describe Papiruby do
  it "has a version number" do
    expect(Papiruby::VERSION).not_to be nil
  end

  describe "EPD" do
    before do
      @epd = Papiruby::EPD.new
      @file_path = "test_img.jpg"
    end
    
    # describe "binary_to_hex" do
    #   it "should return a hex value from binary" do 
    #     expect(@epd.binary_to_hex(@file_path)).to eq("xff")
    #   end
    # end
    
    describe "display" do
      it "should display an image" do
        expect(@epd.display(@file_path)).to eq("")
      end
    end

  end 
end

