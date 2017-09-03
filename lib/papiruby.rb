require "papiruby/version"
require "pry-byebug"

module Papiruby
  def self.write_text(text, **args)
    args[:size] ||= 10
    command = "papirus-write '#{text}' --fsize #{args[:size]}"
    return %x(#{command})
  end

  def self.draw_image(path)
    command = "papirus-draw #{path}"
    return %x(#{command})
  end

  def self.clear
    return %x(papirus-clear)
  end
end
