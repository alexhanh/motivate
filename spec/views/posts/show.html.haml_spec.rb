require 'spec_helper'

describe "posts/show.html.haml" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Title".to_s)
  end
end
