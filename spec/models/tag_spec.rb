require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:admin) { User.create(email: 'user@mail.com', role: 1) }
  let(:post) { Post.create(title: 'first post', short_description: 'Short desc.', user_id: admin.id) }

  it "is valid with valid attributes" do
    expect(Tag.new(name: 'first tag')).to be_valid
  end
  it "is not valid without slug" do
    tag = Tag.create(name: 'first tag')
    tag.slug = nil
    expect(tag).to_not be_valid
  end
  it "is not valid without name" do
    expect(Tag.create(name: nil)).to_not be_valid
  end

  it "is not valid without a unique name" do
    Tag.create(name: 'first tag')
    expect(Tag.new(name: 'first tag')).to_not be_valid
  end

  it "creates slug" do
    tag = Tag.create(name: 'first tag')
    expect(tag.slug).to eq("first-tag")
  end

  it "adds random number to duplicate slug" do
    first_tag = Tag.create(name: 'first tag')
    first_tag.update(name: 'first')
    second_tag = Tag.create(name: 'first tag')
    expect(second_tag.slug).to match(/first-tag-[\da-z]{12}/)
  end
end