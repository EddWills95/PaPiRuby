require "spec_helper"

RSpec.describe Papiruby do
  it "has a version number" do
    expect(Papiruby::VERSION).not_to be nil
  end

  describe "priting text to screen" do
    it "should display some text" do
      expect(Papiruby.write_text("Hello, World")).to eq("Writing to Papirus.......\nFinished!\n")
    end
  end

end
