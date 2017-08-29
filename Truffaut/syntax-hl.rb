#!/usr/bin/env ruby

require 'rouge'

source = ARGV.shift
sourceFileType = ARGV.shift

case sourceFileType
when 'shell'
  lexer = Rouge::Lexers::Shell.new
else
  lexer = Rouge::Lexers::Swift.new
end

formatter = Rouge::Formatters::HTMLInline.new Rouge::Themes::MonokaiSublime.new

result = formatter.format(lexer.lex(source))
puts result
