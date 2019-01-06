#!/usr/bin/env ruby

require 'rouge'

source = ARGV.shift
sourceFileType = ARGV.shift

case sourceFileType
when 'c'
  lexer = Rouge::Lexers::C.new
when 'cpp'
  lexer = Rouge::Lexers::Cpp.new
when 'javaScript'
  lexer = Rouge::Lexers::Javascript.new
when 'objc'
  lexer = Rouge::Lexers::ObjectiveC.new
when 'rust'
  lexer = Rouge::Lexers::Rust.new
when 'shell'
  lexer = Rouge::Lexers::Shell.new
when 'swift'
  lexer = Rouge::Lexers::Swift.new
end

formatter = Rouge::Formatters::HTMLInline.new Rouge::Themes::MonokaiSublime.new

result = formatter.format(lexer.lex(source))
puts result
