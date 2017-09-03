require "papiruby/version"
require "pry-byebug"

module Papiruby
  def self.write_text(text, **args)
    command = ""
    args[:size] ||= 10
    if args[:invert] 
      command = "papirus-write '#{text}' --fsize #{args[:size]} -i INVERT"
    else
      command = "papirus-write '#{text}' --fsize #{args[:size]}"
    end
    return %x(#{command})
  end

  def self.draw_image(path, **args)
    args[:type] ||= "resize"
    args[:rotate] ||= 0
    command = "papirus-draw #{path} -t #{args[:type]} -r #{args[:rotate]}"
    return %x(#{command})
  end

  def self.clear
    return %x(papirus-clear)
  end
end
