require 'rails_helper'

RSpec.describe TagPolicy, type: :policy do
  let(:admin) { User.create(email: 'admin@mail.com', role: :admin) }
  let(:guest_writer) { User.create(email: 'guest_writer@mail.com', role: :guest_writer) }
  let(:user) { User.create(email: 'user@mail.com', role: :user) }
  let(:first_post) { Post.create(title: 'first post', short_description: 'short desc', user_id: guest_writer.id)}
  let(:first_tag) { first_post.tags.create(name: 'first tag') }

  subject { described_class }

  permissions :show? do
    it 'grants all users access to tags' do 
      expect(subject).to permit(user, first_tag)
    end
  end

  permissions :edit?, :update?, :destroy? do
    it 'denies access to non-admin users' do
      expect(subject).not_to permit(guest_writer, first_tag)
    end

    it 'grants all access to admin' do
      expect(subject).to permit(admin, first_tag)
    end
  end

end