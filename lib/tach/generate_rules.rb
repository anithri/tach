module Tach
  class GenerateRules
    attr_reader :parser, :filter, :var_assigner
    def initialize(parser)
      @parser = parser
      @filter = RulesFilter.new
      @var_assigner = Tach::AssignVar.new
    end

    def rules
      @rules ||= generate_rules
    end

    def generate_rules
      new_rules = {}
      parser.each_selector do |selector, declarations, specificity, other|
        media = gen_media(other)
        next unless filter.use?(selector, media)
        new_rules[selector] = {
            'selector'   => selector,
            'properties' => process_properties(declarations),
            'specifity'  => specificity,
            'media'      => media
        }
      end
      puts parser.inspect if new_rules.empty?
      new_rules
    end

    def process_properties(declarations)
      i = gen_properties(declarations)
      var_assigner.process_rules(i)
    end

    # BEWARE
    #   nothing in current tachyons reports with more than one media
    #   past performance is not an indicator of future results
    def gen_media(other)
      other.first.to_s.gsub(%r{([:()]|--breakpoint-)}, '')
    end

    def gen_properties(declarations)
      declarations.split('; ').map {|r| r.end_with?(';') ? r : r + ';'}
    end

  end
end