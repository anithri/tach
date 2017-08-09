require 'yaml'
require 'nokogiri'
require 'pry'
module Tach
  class GenerateTemplate
    EXPECTED_FILE_EXT = '.yml'
    # @param file [String,Pathname] name of file to read
    # @param name [String] section name.  defaults to file.basename
    # @param prefix [String] default: '' is prepended to name if no name is given
    def self.generate(file, name: nil, prefix: '')
      name  = name || (prefix + Pathname(file).basename(EXPECTED_FILE_EXT).to_s)
      rules = YAML.load_file(file)
      self.new(name, rules)
    end

    # @param name [String] name.  also name output filename
    # @param files Array[String,Pathname] name of files to read
    # @param destination_dir [String, Pathname] dir to save templates to
    def self.combine(name, files)
      generator = self.new(name, [])
      Array(files).each do |file|
        generator.rules.concat(YAML.load_file(file).to_a)
      end
      generator
    end

    attr_accessor :name, :rules, :prefix

    # @param name [String] name of this group.  Also the filename it's saved as
    # @param rules Array[Hash[String,Hash]], list of rules as [selector, data] pairs
    #   as read from file
    def initialize(name, rules)
      @name  = name
      @rules = rules
    end

    # @param comment_type [Symbol] default: :none commenting style for templates.
    #   one of [:none, :side, :top]
    def to_xml(comment_type = :none)
      builder ||= Nokogiri::XML::Builder.new do |xml|
        xml.templateSet(group: name) do
          self.rules.each do |(rule_name, data)|
            attrs = attrs(rule_name, data['properties'], comment_type)
            xml.template(attrs) do
              xml.method_missing('context') do
                xml.option(name: 'CSS_DECLARATION_BLOCK', value: true)
              end
            end
          end
        end
      end
      builder.to_xml
    end

    # the file must be saved with the same name as the group attribute on templateSet
    #   for this reason, we get the dir not the path
    # @param directory [String,Pathname] directory to save file to
    # @param comment_type [Symbol] default: :none commenting style for templates.
    #   one of [:none, :side, :top]
    def save(directory, comment_type = :none)
      if !rules.empty?
        File.open(directory + filename, 'w') {|f| f.puts self.to_xml(comment_type)}
      else
        puts "No rules for #{name}"
      end
    end

    def filename
      name + ".xml"
    end

    def attrs(rule_name, properties, comment_type)
      {
          name:             rule_name,
          value:            with_comments(rule_name, properties, comment_type),
          description:      short_comment(rule_name),
          toReformat:       true,
          toShortenFQNames: true
      }
    end

    # TODO REFACTOR if this gets anymore complicated
    def with_comments(rule_name, properties, comment_type)
      puts properties.inspect
      props = Array(properties) + ["$END$"]
      case comment_type
        when :side # first line gets the comment appended to it
          props[0] += " /* #{short_comment(rule_name)} */"
        when :top # comment is added as first line
          props.unshift "/* #{short_comment(name, rule_name)} */"
        else # mostly :none
          # noop
      end
      props.join("\n")
    end

    def short_comment(*parts)
      parts.join(": ")
    end
  end
end

