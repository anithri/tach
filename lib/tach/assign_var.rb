require 'yaml'

RULE_REGEX = /(.+): var\((.+)\);/

module Tach
  class AssignVar

    def initialize
      @data = YAML.load_file('etc/variables.yml')
    end

    def process_rules(rules)
      rules.map do |rule|
        return rule unless rule.include?('var(--')
        (name, var) = rule.match(RULE_REGEX).captures
        val = @data[var]
        val == '--spacing-none' ?  "#{name}: 0;" : "#{name}: var(#{var});"
      end
    end
  end
end
