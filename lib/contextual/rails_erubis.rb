module ActionView
  class Template
    module Handlers
      class Erubis < ::Erubis::Eruby
        def add_preamble(src)
          src << "@output_buffer = output_buffer || Erubis::ContextualBuffer.new; "
        end

        def add_text(src, text)
          if !text.empty?

            src << "@output_buffer.writeSafe '" << text.to_s.gsub("'", "\\\\'") << "';"
          end
        end

        def add_stmt(src, code)
          src << code
          src << ';' unless code[-1] == ?\n
        end

        def add_expr_escaped(src, code)
          src << " @output_buffer.write((" << code << ').to_s);'
        end

        def add_expr_literal(src, code)
          if code =~ BLOCK_EXPR
            src << '@output_buffer.writeSafe ' << code
          else
            src << '@output_buffer.writeSafe (' << code << ');'
          end
        end

        def add_expr_escaped(src, code)
          if code =~ BLOCK_EXPR
            src << "@output_buffer.write " << code
          else
            src << "@output_buffer.write (" << code << ");"
          end
        end

        def add_postamble(src)
          src << "@output_buffer.close \n"
          # src << "p [:CONTEXTUAL @output_buffer.to_s]\n"
          src << "@output_buffer.to_s"
        end
      end
    end
  end
end
