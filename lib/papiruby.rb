require "papiruby/version"

module Papiruby
  def self.write_text(text)
    command = "papirus-write '#{text}'"
    return %x(#{command})
  end
end
