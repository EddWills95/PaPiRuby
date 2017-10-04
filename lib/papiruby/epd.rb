require 'chunky_png'

module ChunkyPNG::Canvas::StreamExporting
    def inspect_bitstream
        #create a simple map of the image of '0's and '1's
        #for debugging purpuses
        pixels.each_slice(self.width).map{|row| row.each_slice(8).map{|pixels|pixels.map{|pixel| pixel == ChunkyPNG::Color::WHITE ? '0' : '1'}.join}.join(' ')}
    end

    def to_bit_stream(inverse = true)
        #as the ChunkyPNG library works with 4 bytes data per pixel (1 byte for R, G, B and transparancy)
        #and the EDP needs 1 bit per pixel (on or off), we need some way to traverse over all pixels
        #and add a bit to a byte stream for each pixel. so

        bytes = []
        #for each 8 pixels (the ChunkyPNG library keeps an array of all pixels used, containing ChunkyPNG::Color elements)
        pixels.each_slice(8).map do |pixels|
            #we create a byte with its bits set to 00000000
            byte = 0
            0.upto(7) do |bit|
                #and switch the bit to 1 (or 0 if not inverse) for each pixel if it was white
                #we have to check pixels[7-bit] as the order is right to left
                byte |= 1 << bit if (inverse && pixels[7-bit] == ChunkyPNG::Color::WHITE) || (!inverse && pixels[7-bit] != ChunkyPNG::Color::WHITE)
            end
            #and add it to the output byte stream
            bytes.push(byte)
        end
        #now we just need to pack all bytes into a file writable string
        bytes.pack('C'*bytes.length)
    end
end

module Papiruby
    class EPD

        attr_accessor :epd_path, :width, :height, :panel, :cog, :film, :auto, :rotation, :inverse, :png

        def initialize(args={})
            self.epd_path = args[:epd_path]|| '/dev/epd'
            self.width = args[:width] || 200
            self.height = args[:height] || 96
            self.panel = args[:panel] || 'EPD 2.0'
            self.cog = args[:cog] || 0
            self.film = args[:film] || 0
            self.auto = args[:auto] || false
            self.inverse = args[:auto] || true
            self.rotation = args[:rotation] || 0
            if args[:file]
                self.png = ChunkyPNG::Image.from_file(pngfile)
            else
                self.png = ChunkyPNG::Image.new(self.width, self.height, ChunkyPNG::Color::WHITE)
            end
        end

        def circle(x, y, radius)
            png.circle(x, y, radius)
        end

        def display
            File.open(File.join(self.epd_path, "LE", "display_inverse"), 'wb') do |io|
                io.write png.to_bit_stream(self.inverse)
            end
            self.fast_update
        end

        def displayfile(pngfile)
            #does not work yet, as pixel not white will turn black, giving a black image
            self.png = ChunkyPNG::Image.from_file(pngfile)

            File.open(File.join(self.epd_path, "LE", "display"), 'wb') do |io|
                io.write self.png.to_bit_stream(self.inverse)
            end

            # Call the update
            self.update
        end

        def fast_update()
            self._command('F')
        end

        def partial_update()
            self._command('P')
        end

        def update()
            self._command('U')
        end

        def clear()
            self._command('C')
        end

        def _command(c)
            f = File.new(File.join(self.epd_path, "command"), "wb")
            f.write(c)
        end
    end
end

#basic test of drawing some circles
canvas = Papiruby::EPD.new({width:264, height: 176})
canvas.clear()
10.step(70, 5) do |radius|
    canvas.circle(canvas.width/2, canvas.height/2, radius)
    canvas.display()
end
