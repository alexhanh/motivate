require File.dirname(__FILE__) + "/spec_helper"
require "machinist/mongo_mapper"

Spec::MongoMapper.configure!

class Address
  include MongoMapper::EmbeddedDocument
  
  key :street, String
  key :zip, String
  key :country, String
end

class Person
  include MongoMapper::Document
  
  key :name, String
  key :type, String
  key :password, String
  key :admin, Boolean, :default => false
  key :address, Address
end

class Post
  include MongoMapper::Document
  
  key :title, String
  key :body, String
  key :published, Boolean, :default => true
  
  many :comments
end

class Comment
  include MongoMapper::Document
  
  key :body, String
  key :post_id, String
  key :author_id, String
  
  belongs_to :post
  belongs_to :author, :class_name => "Person"
end

describe Machinist, "MongoMapper::Document adapter" do 

  before(:each) do
    Person.clear_blueprints!
    Post.clear_blueprints!
    Comment.clear_blueprints!
  end

  describe "make method" do
    it "should save the constructed object" do
      Person.blueprint { }
      person = Person.make
      person.should_not be_new
    end

    it "should create an object through belongs_to association" do
      Post.blueprint { }
      Comment.blueprint { post }
      Comment.make.post.class.should == Post
    end
      
    it "should create an object through belongs_to association with a class_name attribute" do
      Person.blueprint { }
      Comment.blueprint { author }
      Comment.make.author.class.should == Person
    end
    
    it "should create an object through belongs_to association using a named blueprint" do
      Post.blueprint { }
      Post.blueprint(:dummy) do
        title { 'Dummy Post' }
      end
      Comment.blueprint { post(:dummy) }
      Comment.make.post.title.should == 'Dummy Post'
    end
  end

  describe "plan method" do
    it "should not save the constructed object" do
      person_count = Person.count
      Person.blueprint { }
      person = Person.plan
      Person.count.should == person_count
    end
    
    it "should return a regular attribute in the hash" do
      Post.blueprint { title "Test" }
      post = Post.plan
      post[:title].should == "Test"
    end
    
    it "should create an object through a belongs_to association, and return its id" do
      Post.blueprint { }
      Comment.blueprint { post }
      post_count = Post.count
      comment = Comment.plan
      Post.count.should == post_count + 1
      comment[:post].should be_nil
      comment[:post_id].should_not be_nil
    end

    context "attribute assignment" do 
      it "should allow assigning a value to an attribute" do
        Post.blueprint { title "1234" }
        post = Post.make
        post.title.should == "1234"
      end

      it "should allow arbitrary attributes on the base model in its blueprint" do
        Post.blueprint { foo "bar" }
        post = Post.make
        post.foo.should == "bar"
      end
    end
  end

  describe "make_unsaved method" do
    it "should not save the constructed object" do
      Person.blueprint { }
      person = Person.make_unsaved
      person.should be_new
    end
    
    it "should not save associated objects" do
      pending
      # Post.blueprint { }
      # Comment.blueprint { post }
      # comment = Comment.make_unsaved
      # comment.post.should be_new
    end
    
    it "should save objects made within a passed-in block" do
      Post.blueprint { }
      Comment.blueprint { }
      comment = nil
      post = Post.make_unsaved { comment = Comment.make }
      post.should be_new
      comment.should_not be_new
    end
  end

end

describe Machinist, "MongoMapper::EmbeddedDocument adapter" do 

  before(:each) do
    Person.clear_blueprints!
    Address.clear_blueprints!
  end

  describe "make method" do
    it "should construct object" do
      Address.blueprint { }
      address = Address.make
      address.should be_instance_of(Address)
    end

    it "should make an embed object" do
      Address.blueprint { }
      Person.blueprint do
        address { Address.make }
      end
      Person.make.address.should be_instance_of(Address)
    end

    it "should allow arbitrary attributes on the base model in its blueprint" do
      Address.blueprint { foo "bar" }
      addr = Address.make
      addr.foo.should == "bar"
    end
  end

end
