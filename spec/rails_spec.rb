require 'rails'

require 'contextual'

# make sure railtie is loaded in case some other
# test task required contextual before rails was loaded
require 'contextual/rails'

# Force the load hooks to be run for action_view
require 'action_view'
require 'action_view/base'

describe "Contextual load hooks" do
  it "should add SafeErubis as template handler" do
    ActionView::Template::Handlers::SafeErubis.should == Contextual::SafeErubis
  end

  it "should be able to load action_view/buffers alright" do
    require 'action_view/buffers'
  end
end
