require 'css_parser'
require 'pathname'
require 'yaml'

module Tach
  class ConvertStylesheet

    SECTION_REGEX = /(_|\.css)/

    attr_reader :file_path, :parser, :rules

    def self.convert(file, destination_dir)
      converter = self.new(file, destination_dir) do |c|
        c.parse!
        c.convert
        c.save
      end
    end

    def initialize(file, destination_dir, &block)
      @file_path = Pathname(file)
      @save_path = Pathname(destination_dir) + "#{section}.yml"
      @parser    = CssParser::Parser.new
      yield self
    end

    def save
      File.open(@save_path, 'w'){|f| f.write self.rules.to_yaml}
    end

    def convert
      @rules ||= GenerateRules.new(parser).rules
    end

    def parse!
      parser.load_file!(filename, src_dir)
    end

    def section
      filename.gsub(SECTION_REGEX, '')
    end

    def filename
      file_path.basename.to_s
    end

    def src_dir
      file_path.dirname.to_s
    end

  end
end