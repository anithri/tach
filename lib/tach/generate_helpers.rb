require 'yaml'
require 'nokogiri'
require 'pry'
module Tach
  class GenerateHelpers
    EXPECTED_FILE_EXT = '.yml'
    COLOR_REGEX       = /\s*(\#[0-9a-f]{6,8}|rgba)/
    # @param file [String,Pathname] name of file to read
    def self.generate(file)
      rules = YAML.load_file(file)
      self.new(rules)
    end

    def color_rules(comment_type)
      find_colors(comment_type)
    end

    attr_accessor :name, :rules, :prefix

    # @param rules Array[Hash[String,Hash]], list of rules as [selector, data] pairs
    #   as read from file
    def initialize(rules)
      @rules = rules
    end


    def to_xml(comment_type = :none)
      builder ||= Nokogiri::XML::Builder.new do |xml|
        xml.templateSet(group: "TachyonVariables") do
          self.rules.each do |(rule_name, value)|
            attrs = attrs(rule_name, value, comment_type)
            xml.template(attrs) do
              xml.method_missing('context') do
                xml.option(name: 'CSS_DECLARATION_BLOCK', value: true)
              end
            end
          end
          self.color_rules(comment_type).each do |attrs|
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
    def save(filename, comment_type = :none)
      if !rules.empty?
        File.open(filename, 'w') {|f| f.puts self.to_xml(comment_type)}
      else
        puts "No rules for #{name}"
      end
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
    def with_comments(rule_name, value, comment_type)
      body = short_comment(rule_name)
      case comment_type
      when :side # first line gets the comment appended to it
        body += " /* #{short_comment(rule_name)} */"
      when :top # comment is added as first line
        body = "/* #{short_comment(rule_name)} */\n" + body
      else # mostly :none
        # noop
      end
      body
    end

    def short_comment(rule_name)
      "var(#{rule_name})"
    end

    def find_colors(comment_type)
      rules
        .each_pair
        .select {|(name, val)| val.match(COLOR_REGEX)}
        .map do |(name, val)|
          body = if comment_type == :side
                   "var(#{name})$END$ /* = #{val} */"
                 else
                   "var(#{name})$END$"
                 end

          {
            name:             name[2..-1],
            value:            body,
            description:      name,
            toReformat:       true,
            toShortenFQNames: true
          }
      end
    end
  end
end

