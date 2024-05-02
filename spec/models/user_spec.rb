require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    expect(User.new(email: 'me@mail.com')).to be_valid
  end
  it "is not valid without a email" do
    expect(User.new(email: nil)).to_not be_valid
  end
  it "is not valid without a unique email" do
    User.create(email:'me@mail.com')
    expect(User.new(email: 'me@mail.com')).to_not be_valid
  end
end
