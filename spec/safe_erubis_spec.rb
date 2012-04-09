require 'contextual/safe_erubis'

describe Contextual do
  it 'should allow fixnums' do
    template = Contextual::SafeErubis.new <<-TEMPLATE
    Number: <%= 42 %>
    TEMPLATE

    result = template.result(binding)

    result.should =~ /Number:\s*42/
  end

  private

  def output_buffer
    ::Erubis::ContextualBuffer.new
  end
end
