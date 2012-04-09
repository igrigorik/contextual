module Contextual
  class SafeErubis < ::Erubis::Eruby
    BLOCK_EXPR = /\s+(do|\{)(\s*\|[^|]*\|)?\s*\Z/

      def add_preamble(src)
        src << "@output_buffer = output_buffer || Erubis::ContextualBuffer.new; "
      end

    def add_text(src, text)
      if !text.empty?
        src << "@output_buffer.concat('" << text.to_s.gsub("'", "\\\\'") << "');"
      end
    end

    def add_expr_literal(src, code)
      if code =~ BLOCK_EXPR
        src << '@output_buffer.append= ' << code
      else
        src << <<-SRC
              val = (#{code.to_s});
              if (val.html_safe?);
                @output_buffer.append=(val);
              else;
                @output_buffer.safe_append=(val);
              end;
        SRC
      end
    end

    def add_expr_escaped(src, code)
      if code =~ BLOCK_EXPR
        src << "@output_buffer.append= " << code
      else
        src << "@output_buffer.append(" << code << ");"
      end
    end

    def add_postamble(src)
      src << "@output_buffer.close \n"
      # src << "p [:CONTEXTUAL,@output_buffer, @output_buffer.to_s, @output_buffer.to_s.html_safe.html_safe?]\n"
      src << "@output_buffer.to_s.html_safe"
    end
  end
end
