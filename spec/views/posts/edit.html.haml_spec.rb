require 'spec_helper'

describe "posts/edit.html.haml" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :new_record? => false,
      :title => "MyString"
    ))
  end

  it "renders the edit post form" do
    render

    rendered.should have_selector("form", :action => post_path(@post), :method => "post") do |form|
      form.should have_selector("input#post_title", :name => "post[title]")
    end
  end
end
