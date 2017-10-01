require 'base64'
require 'mini_magick'
require 'chunky_png'
require 'pry-byebug'

class Papiruby::EPD

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
    self.clear
    
    # # Write back to the file

    @new_image = binary_to_hex(file)

    
    @epd_display = File.new(File.join(self.epd_path, "LE", "display_inverse"), 'wb')

    File.open(File.join(self.epd_path, "LE", "display_inverse"), 'wb') do |file|
      file.write ""

      
      file.write @new_image
    end

    # File.open(File.join(self.epd_path, "LE", "display_inverse"), 'rb') { |file| file.write(@new_image) }

    # File.binwrite(File.join(self.epd_path, "LE", "display_inverse"), @new_image)

    # Call the update
    self.update

  end

  def binary_to_hex(file)
    convert_file(file)
    bin = File.binread("output.jpg")
    binary = bin.unpack('C*')
    string_to_write = binary.pack("CS*")
  
    return string_to_write
  end

  def convert_file(file)
    MiniMagick::Tool::Convert.new do |convert|
      convert << file
      convert << "-colorspace" << "Gray"
      convert << "-resize" << "#{self.width}x#{self.height}"
      convert << "-quality" << "1"
      convert << "output.jpg"
    end
  end

  def update()
    self._command('U')
  end
  
  def clear()
    self._command('C')
  end

  def _command(c)
    f = File.new(File.join(self.epd_path, "command"), "w")
    f.write(c)
  end
end