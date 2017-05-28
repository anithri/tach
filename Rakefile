require 'css_parser'
require 'yaml'

TACHYONS_DIR = './node_modules/tachyons-custom/src/'
DESTINATION_DIR = './build/'
GLOB_PATTERN = '_*.css'

directory 'build'

task :check_install => 'build' do
  unless Dir.exist?(TACHYONS_DIR)
    abort("#{TACHYONS_DIR} does not exist.\nPlease run yarn to install")
  end
end

files_to_convert = Rake::FileList[TACHYONS_DIR + GLOB_PATTERN]

task convert_files: [:check_install, *files_to_convert] do
  parser = CssParser::Parser.new

  files_to_convert.each do |path|
    (*dir, filename) = path.split('/')
    parser.load_file!(filename, TACHYONS_DIR)

    output = {}

    parser.each_selector do |selector, declarations, specificity, other|
      output[selector] = {
          selector: selector,
          properties: declarations,
          media: other
      }
    end

    save_file = DESTINATION_DIR + filename.gsub('_','').gsub('.css','') + '.yml'

    File.open(save_file,'w'){|f| f.write output.to_yaml}
  end
end
