# Runtime Contextual Autoescaper

A JRuby wrapper for [Mike Samuel's contextual HTML autoescaper](https://github.com/mikesamuel/html-contextual-autoescaper-java). 

## Example

First, let's define an Erb template:

```erb
<% def helper(obj); "Hello, #{obj['world']}"; end %>

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

```html
<div style="color: blue">
<a href="/blue?q=%3cCincinnati%3e" onclick="alert('Hello, \x3cCincinnati\x3e');return false">Hello, &lt;Cincinnati&gt;</a>
<script>(function () {
 var o = {'world':'\x3cCincinnati\x3e','color':'blue'},
 w = "\x3cCincinnati\x3e";
})();</script>
</div>
```

The safe parts are treated as literal chunks of HTML/CSS/JS, the query string parameters are auto URI encoded, same data is also auto escaped within the JS block, and the rendered object within the javascript block is automatically converted to JSON! Additionally, extra comments are removed, data is properly HTML escaped, and so forth.

Contextual will also automatically strip variety of injection cases for JS, CSS, and HTML, and give you a [dozen other features](https://github.com/mikesamuel/html-contextual-autoescaper-java/tree/master/src/tests/com/google/autoesc) for free.

