require 'yaml'
require 'nokogiri'

module Tach
  class GenerateTemplate
    EXPECTED_FILE_EXT = '.yml'
    COMMENT_TYPES     = [:name, :short, :verbose]

    # @param file [String,Pathname] name of file to read
    # @param destination_dir [String, Pathname] dir to save templates to
    # @param comments [Symbol, String] commenting style for templates.
    #   one of [:none, :short, :verbose]
    # @param name [String] section name.  defaults to file.basename
    def self.generate(file, destination_dir, comments: :short, name: nil)
      section  = name || Pathname(file).basename(EXPECTED_FILE_EXT).to_s
      comments = comments.intern
      rules           = YAML.load_file(file)
      s               = self.new(name, rules, comments)
    end

    # @param name [String] name.  also name output filename
    # @param files Array[String,Pathname] name of files to read
    # @param destination_dir [String, Pathname] dir to save templates to
    # @param comments [Symbol, String] commenting style for templates.
    #   one of [:none, :short, :verbose]
    def self.combine(name, files, destination_dir, comments: :short)
      generator = self.new(name, [], comments)
      Array(files).each do |file|
        generator.rules.concat(YAML.load_file(file).to_a)
      end
      generator
    end

    attr_reader :name, :rules, :prefix

    # @param name [String] name of this group.  Also the filename it's saved as
    # @param rules Array[Hash[String,Hash]], list of rules as [selector, data] pairs
    #   as read from file
    # @param comments [Symbol] commenting style for templates.
    #   one of [:none, :short, :verbose]
    def initialize(name, rules, comments)
      @name     = name
      @rules    = rules
      @comments = comments
    end

    def to_xml
      @builder ||= Nokogiri::XML::Builder.new do |xml|
        xml.templateSet(group: name) do
          self.rules.each do |(rule_name, data)|
            values = data['properties'].join("\n") + "\n$END$"
            attrs  = attrs(rule_name, values)
            xml.template(attrs) do
              xml.method_missing('context') do
                xml.option(name: 'CSS_DECLARATION_BLOCK', value: true)
              end
            end
          end
        end
      end
      @builder.to_xml
    end

    # the file must be saved with the same name as the group attribute on templateSet
    #   for this reason, we get the dir not the path
    def save(directory)
      if ! rules.empty?
        File.open(directory + filename, 'w') {|f| f.puts self.to_xml}
      else
        puts "No rules for #{name}"
      end
    end


    def filename
      name + ".xml"
    end

    def attrs(rule_name, values)
      {
          name:             rule_name,
          value:            comments(rule_name) + values,
          description:      comments(rule_name, comments: true),
          toReformat:       false,
          toShortenFQNames: true
      }
    end

    def comments(rule_name, comments: @comments)
      @comments ? "/* #{name}: #{rule_name} */\n" : ''
    end
  end
end

