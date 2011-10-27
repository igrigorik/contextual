require "java"
require "ext/guava"
require "ext/autoesc"

java_import com.google.autoesc.HTMLEscapingWriter

require "rubygems"
require "erubis"

module Erubis
  module ContextualEscapeEnhancer

    def self.desc   # :nodoc:
      "switch '<%= %>' to escaped and '<%== %>' to unescaped"
    end

    def add_expr(src, code, indicator)
      case indicator
      when '='
        @escape ? add_expr_literal(src, code) : add_expr_escaped(src, code)
      when '=='
        @escape ? add_expr_escaped(src, code) : add_expr_literal(src, code)
      when '==='
        add_expr_debug(src, code)
      end
    end

    def add_text(src, text)
      if !text.empty?
        src << " #{@bufvar}.writeSafe '" << text.to_s.gsub("'", "\\\\'") << "';"
      end
    end

    def add_stmt(src, code)
      src << code
      src << ';' unless code[-1] == ?\n
    end

    def add_expr_literal(src, code)
      src << " #{@bufvar}.writeSafe(" << code << ').to_s;'
    end

    def add_expr_escaped(src, code)
      src << " #{@bufvar}.write(" << code << ').to_s;'
    end
  end

  class ContextualBuffer
    def initialize
      @writer = java.io.StringWriter.new
      @buf = HTMLEscapingWriter.new(@writer)
    end

    def writeSafe(code)
      @buf.writeSafe(code)
    end

    def write(code)
      @buf.write(code)
    end

    def to_s
      @writer.to_s
    end

    def close
      @writer.close
    end
  end

  class ContextualEruby < Eruby
    include ContextualEscapeEnhancer

    def add_preamble(src)
      src << "#{@bufvar} = Erubis::ContextualBuffer.new; "
    end

    def add_postamble(src)
      src << "\n" unless src[-1] == ?\n
      src << "#{@bufvar}.close\n"
      src << "#{@bufvar}.to_s\n"
    end
  end
end
