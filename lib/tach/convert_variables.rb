require 'pathname'
require 'yaml'
module Tach
  class ConvertVariables
    RULE_REGEX = /^\s+(--[\w-]+): (.+);$/

    def self.convert(input_file, output_file)
      converter = self.new(input_file, output_file) do |c|
        c.load_file
        c.process_contents
        c.save
      end
    end
    def initialize(input_file, output_file, &block)
      @input_file = input_file
      @output_file = output_file
      @data = {}
      yield self
    end

    def save
      File.open(@output_file,'wb'){|f| f.puts @data.to_yaml}
    end

    def load_file
      @contents = File.open(@input_file).readlines
    end

    def process_contents
      @contents.select{|l| l.match(RULE_REGEX)}.each do |rule|
        (key, value) = rule.match(RULE_REGEX).captures
        @data[key] = value
      end
    end
  end
end