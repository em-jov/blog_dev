require 'rails_helper'

RSpec.describe Post, type: :model do
  it "is valid with valid attributes" do
    expect(Post.new(title: 'first post', short_description: 'Short desc.')).to be_valid
  end
  it "is not valid without slug" do
    post = Post.create(title: 'first post', short_description: 'Short desc.')
    post.slug = nil
    expect(post).to_not be_valid
  end
  it "is not valid without title" do
    expect(Post.new(title: nil, short_description: 'Short desc.')).to_not be_valid
  end
  it "is not valid without a short description" do
    expect(Post.new(title: 'first post', short_description: nil)).to_not be_valid
  end
  it "is not valid without a unique title" do
    Post.create(title: 'first post', short_description: 'Short desc.')
    expect(Post.new(title: 'first post', short_description: 'Short desc.')).to_not be_valid
  end
  it "creates slug" do
    post = Post.create(title: 'first post', short_description: 'Short desc.')
    expect(post.slug).to eq("first-post")
  end
  it "adds random number to duplicate slug" do
    first_post = Post.create(title: 'first post', short_description: 'Short desc.')
    first_post.update(title: 'first')
    second_post = Post.create(title: 'first post', short_description: 'Short desc.')
    expect(second_post.slug).to match(/first-post-[\da-z]{12}/)
  end
end
