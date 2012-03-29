require "contextual"

TEMPLATE = <<-eos
<% def helper(obj); "Hello, \#{obj['world']}"; end %>

<div style="color: <%= object['color'] %>">
<a href="/<%= object['color'] %>?q=<%= object['world'] %>" onclick="alert('<%= helper(object) %>');return false"><%= helper(object) %></a>
<script>(function () {  // Sleepy developers put sensitive info in comments.
 var o = <%= object %>,
 w = "<%= object['world'] %>";
})();</script>
</div>
eos

EXPECTED = <<-eos

<div style="color: blue">
<a href="/blue?q=%3cCincinnati%3e" onclick="alert('Hello, \\x3cCincinnati\\x3e');return false">Hello, &lt;Cincinnati&gt;</a>
<script>(function () {
 var o = {'world':'\\x3cCincinnati\\x3e','color':'blue'},
 w = "\\x3cCincinnati\\x3e";
})();</script>
</div>
eos

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

  it "should render contextual template" do
    object = {"world" => "<Cincinnati>", "color" => "blue"}
    template = Erubis::ContextualEruby.new(TEMPLATE)
    res = template.result(binding())

    # don't worry about trailing whitespace
    res = res.split("\n").map {|r| r.strip}
    exp = EXPECTED.split("\n").map {|r| r.strip}

    res.should == exp
  end

  it "should render fixnums" do
    template = Erubis::ContextualEruby.new <<-TEMPLATE
    Number: <%= 42 %>
    TEMPLATE

    result = template.result(binding)

    result.should =~ /Number: 42/
  end
end
