# frozen_string_literal: true

# Converts stylesheet files with px measurements
# to any other unit based on a scale
class PixelConverter
  def self.convert_to(unit, scale, file)
    new(unit, scale, file).convert
  end

  def convert
    new_name = file.dup.insert(file.rindex("."), ".copy")
    copy     = File.new(new_name, "w")
    copy.puts(converted)
    copy.close
    true
  end

  def converted
    lines.map do |line|
      px_matches = line.scan(px_regex)

      unless px_matches.empty?
        px_matches.each do |match|
          new_value = match.split(/(px)/)[0].to_f / scale
          line.gsub!(match, "#{new_value}#{unit}")
        end
      end

      line
    end.join("\n")
  end

  private

  attr_reader :file,
              :scale,
              :unit

  def initialize(unit, scale, file)
    @unit  = unit
    @file  = file
    @scale = scale
  end

  def lines
    @lines ||= raw_file.split("\n")
  end

  def raw_file
    File.read(file)
  end

  def px_regex
    /\d+px/
  end
end
