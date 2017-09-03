require 'base64'
require 'mini_magick'
require 'pry-byebug'

class EPD

  attr_accessor :epd_path, :width, :height, :panel, :cog, :film, :auto, :rotation 

  def initialize(*args, **kwags)
    self.epd_path = '/dev/epd'
    self.width = 200
    self.height = 96
    self.panel = 'EPD 2.0'
    self.cog = 0
    self.film = 0
    self.auto = false
    self.rotation = 0

  end

  def display(file)
    # Open file
    image_file = MiniMagick::Image.open(file)
    # Convert to Greyscale & save
    image_file.colorspace "Gray"
    image_file.write "tmp.img"
    # Encode into base 64
    image_bytes = File.open("tmp.img")
    
    # open EPD file
    f = File.new(File.join(self.epd_path, "LE", "display_inverse"), "w+")
    # Write that bytecode to the file
    
    f.write(image_bytes)

    # Update the screen
    self.update()
  end

  def update()
    self._command('U')
  end

  def _command(c)
    f = File.new(File.join(self.epd_path, "command"), "w")
    f.write(c)
  end
end

epd = EPD.new

epd.display("./test_img.jpg")