require_relative 'lib/tach'
require 'rake/clean'
require 'pathname'

# these provide things that don't fit as live templates
EXCLUDED_SRC_FILES = %w{_skins-pseudo.css _styles.css _module-template.css
                      _links.css _lists.css _overflow.css
                      _tables.css _utilities.css _hovers.css
                      _debug-children.css _debug-grid.css _code.css
                      _debug.css _normalize.css _images.css
                      _variables.css _font-family.css
}.map {|f| '**/' + f}

TACHYONS_DIR   = Pathname('./node_modules/tachyons-custom/src/').expand_path
RULES_DIR      = Pathname('./rules/').expand_path
TEMPLATE_DIR   = Pathname('./templates/').expand_path
ETC_DIR        = Pathname('./etc').expand_path
VARIABLES_FILE = ETC_DIR + 'variables.yml'
MODULES_NONE   = TEMPLATE_DIR + 'modules'
MODULES_SIDE   = TEMPLATE_DIR + 'modules-side-comments'
# noinspection RubyInterpreter
MODULES_TOP    = TEMPLATE_DIR + 'modules-top-comments'
VARIABLES_NONE = TEMPLATE_DIR + 'variables.xml'
VARIABLES_SIDE = TEMPLATE_DIR + 'variables-side-comments.xml'

STYLESHEET_GLOB_PATTERN = '_*.css'
RULES_GLOB_PATTERN      = '*.yml'

directory RULES_DIR
directory TEMPLATE_DIR
directory MODULES_NONE
directory MODULES_SIDE
directory MODULES_TOP

CLOBBER.include(RULES_DIR.to_s + '/*', TEMPLATE_DIR.to_s + '/**/*.xml')
task :check_install do
  unless TACHYONS_DIR.exist?
    abort("#{TACHYONS_DIR} does not exist.\nPlease run yarn to install")
  end
end

files_to_convert = Rake::FileList[TACHYONS_DIR.to_s + '/' + STYLESHEET_GLOB_PATTERN].exclude(*EXCLUDED_SRC_FILES)

desc 'convert variables file to yaml'
task variables: [:check_install, RULES_DIR, *files_to_convert] do
  Tach::ConvertVariables.convert(TACHYONS_DIR + '_variables.css', VARIABLES_FILE)
end


desc 'convert tachyons css to yaml'
task convert: :variables do
  files_to_convert.each do |file|
    Tach::ConvertStylesheet.convert(file, RULES_DI1R)
  end
end

files_to_generate = Rake::FileList[RULES_DIR.to_s + '/' + RULES_GLOB_PATTERN]
desc 'convert tachyons rules to xml'
task generate: [RULES_DIR, TEMPLATE_DIR, MODULES_NONE,
                MODULES_SIDE, MODULES_TOP, *files_to_generate] do
  file 'config/database.yml' => 'config/database.yml.example' do
    cp 'config/database.yml.example', 'config/database.yml'
  end

  t = Tach::GenerateTemplate.combine('tachyons', files_to_generate)
  t.save(TEMPLATE_DIR, :none)
  t.save(MODULES_NONE, :none)
  t.save(MODULES_SIDE, :side)
  t.save(MODULES_TOP, :top)

  files_to_generate.each do |file|
    t = Tach::GenerateTemplate.generate(file, prefix: 'tach-')
    t.save(MODULES_NONE, :none)
    t.save(MODULES_SIDE, :side)
    t.save(MODULES_TOP, :top)
  end

  t = Tach::GenerateHelpers.generate(VARIABLES_FILE)
  t.save(VARIABLES_NONE, :none)
  t.save(VARIABLES_SIDE, :side)

end
