require_relative 'lib/tach'
require 'rake/clean'
require 'pathname'

# these provide things that don't fit as live templates
EXCLUDED_SRC_FILES = ['_skins-pseudo.css', '_styles.css', '_module-template.css',
                      '_links.css', '_lists.css', '_overflow.css',
                      '_tables.css', '_utilities.css', '_hovers.css',
                      '_debug-children.css', '_debug-grid.css', '_code.css',
                      '_debug.css','_normalize.css', '_images.css',
                      '_variables.css'
].map {|f| '**/' + f}

TACHYONS_DIR            = Pathname('./node_modules/tachyons-custom/src/').expand_path
RULES_DIR               = Pathname('./rules/').expand_path
TEMPLATE_DIR            = Pathname('./templates/').expand_path
STYLESHEET_GLOB_PATTERN = '_*.css'
RULES_GLOB_PATTERN      = '*.yml'

directory RULES_DIR
directory TEMPLATE_DIR

CLOBBER.include(RULES_DIR.to_s + '/*', TEMPLATE_DIR.to_s + '/*')
task :check_install do
  unless TACHYONS_DIR.exist?
    abort("#{TACHYONS_DIR} does not exist.\nPlease run yarn to install")
  end
end

files_to_convert = Rake::FileList[TACHYONS_DIR.to_s + '/'+ STYLESHEET_GLOB_PATTERN].exclude(*EXCLUDED_SRC_FILES)

desc 'convert tachyons css to yaml'
task convert: [:check_install, RULES_DIR, *files_to_convert] do
  files_to_convert.each do |file|
    Tach::ConvertStylesheet.convert(file, RULES_DIR)
  end
end

files_to_generate = Rake::FileList[RULES_DIR.to_s + '/'+ RULES_GLOB_PATTERN]
desc 'convert tachyons rules to xml'
task generate: [TEMPLATE_DIR, *files_to_generate] do
  s = Tach::GenerateTemplate.combine('tach-all', files_to_generate, comments: :none)
  s.to_xml
  s.save(TEMPLATE_DIR)
end


