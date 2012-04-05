require 'contextual/safe_erubis'

ActiveSupport.on_load(:action_view) do
  ActionView::Template::Handlers::SafeErubis = Contextual::SafeErubis
  ActionView::Template::Handlers::ERB.erb_implementation = Contextual::SafeErubis

  # Make sure ActionView::OutputBuffer is loaded before we override it
  require 'action_view/buffers'
  ActionView::OutputBuffer = ::Erubis::ContextualBuffer
end
