# Runtime Contextual Autoescaper

A JRuby wrapper for [Mike Samuel's contextual HTML autoescaper](https://github.com/mikesamuel/html-contextual-autoescaper-java). A quick example of the escaper at work:

```ruby
<% def helper(obj); "Hello, \#{obj['world']}"; end %>

<div style="color: <%= object['color'] %>">
<a href="/<%= object['color'] %>?q=<%= object['world'] %>" onclick="alert('<%= helper(object) %>');return false"><%= helper(object) %></a>
<script>(function () {  // Sleepy developers put sensitive info in comments.
 var o = <%= object %>,
 w = "<%= object['world'] %>";
})();</script>
</div>
```

Let's load the template and execute it:
```ruby
template = Erubis::ContextualEruby.new(template_string)

object = {"world" => "<Cincinnati>", "color" => "blue"}
puts template.result(binding())
```

Output:

```
<div style="color: blue">
<a href="/blue?q=%3cCincinnati%3e" onclick="alert('Hello, \x3cCincinnati\x3e');return false">Hello, &lt;Cincinnati&gt;</a>
<script>(function () {
 var o = {'world':'\x3cCincinnati\x3e','color':'blue'},
 w = "\x3cCincinnati\x3e";
})();</script>
</div>
```

The safe parts are treated as literal chunks of HTML/CSS/JS, the object rendered within a javascript block is automatically encoded into JSON, and appropriate values are automatically escaped (same applies for css, removing extra comments, etc).