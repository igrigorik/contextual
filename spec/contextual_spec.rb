require "contextual"

describe Contextual do

  it "should escape unsafe content" do
    t = Erubis::ContextualEruby.new(" \
      <% elements.each do |e| %> \
        <%= e %> \
      <% end %> \
    ")

    elements = ['<script>', '&bar', 'style="test"']
    res = t.result(binding())

    res.should match('&lt;script&gt;')
    res.should match('&amp;bar')
    res.should match('style=&#34;test&#34;')
  end

  it "should preserve safe content" do
    t = Erubis::ContextualEruby.new("<ul><%= '<script>' %></ul>")
    t.result.should match('<ul>&lt;script&gt;</ul>')
  end

  it "should allow explicit safe content" do
    t = Erubis::ContextualEruby.new("<ul><%== '<script>' %></ul>")
    t.result.should match('<ul><script></ul>')
  end

  it "should skip comments" do
    t = Erubis::ContextualEruby.new("<%# some comment %>")
    t.result.should be_empty
  end

end
