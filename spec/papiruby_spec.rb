require "spec_helper"

RSpec.describe Papiruby do
  it "has a version number" do
    expect(Papiruby::VERSION).not_to be nil
  end

  describe "priting text to screen" do
    it "should display some text" do
      expect(Papiruby.write_text("Hello, World")).to eq("Writing to Papirus.......\nFinished!\n")
    end

    it "should alter the size" do
      expect(Papiruby.write_text("Hello, World", size: 20)).to eq("Writing to Papirus.......\nFinished!\n")
    end
  end

  describe "displaying picture" do
    it "should display an image" do
      expect(Papiruby.draw_image("./test_img.jpg")).to eq("Drawing on PaPiRus.......\nLandscape image resized!\n")
    end
    it "should display an image with crop" do
      expect(Papiruby.draw_image("./test_img.jpg", type: "crop")).to eq("Drawing on PaPiRus.......\nLandscape image cropped!\n")
    end
  end

  describe "clearing the screen" do
    it "should clear the screen" do
      expect(Papiruby.clear).to eq("Clearing Papirus.......\nFinished!\n")
    end
  end

end
