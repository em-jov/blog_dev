require 'rails_helper'

RSpec.describe PostPolicy, type: :policy do
  let(:admin) { User.create(email: 'admin@mail.com', role: :admin) }
  let(:guest_writer) { User.create(email: 'guest_writer@mail.com', role: :guest_writer) }
  let(:user) { User.create(email: 'user@mail.com', role: :user) }
  let(:first_post) { Post.create(title: 'first post', short_description: 'short desc', user_id: guest_writer.id)}
  let(:second_post) { Post.create(title: 'second post', short_description: 'short desc', user_id: admin.id)}
  let(:third_post) { Post.create(title: 'third post', short_description: 'short desc', user_id: admin.id, is_private: false)}
  let(:completed_post) { Post.create(title: 'completed post', short_description: 'short desc', user_id: guest_writer.id, draft: false)}
  let(:published_post) { Post.create(title: 'published post', short_description: 'short desc', user_id: guest_writer.id, is_private: false)}
  let(:scope_guest_writer) { Pundit.policy_scope!(guest_writer, Post) } 
  let(:scope_admin) { Pundit.policy_scope!(admin, Post) } 
  let(:scope_user) { Pundit.policy_scope!(user, Post) } 

  subject { described_class }

  permissions ".scope" do
    before do
      first_post
      second_post
      third_post
    end

    it 'grants admin access to all the posts' do
      expect(scope_admin.to_a).to match_array([first_post, second_post, third_post])
    end

    it 'grants guest writer full access to posts created by them' do
      expect(scope_guest_writer.to_a).to match_array([first_post])
    end

    it 'grants all users access to published posts only' do
      expect(scope_user.to_a).to match_array([third_post])
    end
    
  end

  permissions :show? do
    it 'grants all users access to published posts' do 
      expect(subject).to permit(user, third_post)
    end

    it 'grants users access to their private posts' do 
      expect(subject).to permit(guest_writer, first_post)
    end
  end

  permissions :new?, :create? do
    it 'denies access if user is not an admin or guest writer' do
      expect(subject).not_to permit(user, Post.new)
    end

    it 'grants access if user is a guest writer' do
      expect(subject).to permit(guest_writer, Post.new)
    end
  end

  permissions :edit?, :update? do
    it 'grants access to user who created the post' do
      expect(subject).to permit(guest_writer, first_post)
    end

    it 'denies access to user who did not created the post' do
      expect(subject).not_to permit(guest_writer, second_post)
    end

    it 'grants all access to admin' do
      expect(subject).to permit(admin, first_post)
    end
    
    it 'denies access to completed post (not a draft)' do
      expect(subject).not_to permit(guest_writer, completed_post)
    end

    it 'denies access to published post' do
      expect(subject).not_to permit(guest_writer, published_post)
    end
  end

  permissions :destroy?, :draft? do
    it 'grants access to user who created the post' do
      expect(subject).to permit(guest_writer, first_post)
    end

    it 'denies access to user who did not created the post' do
      expect(subject).not_to permit(guest_writer, second_post)
    end

    it 'grants all access to admin' do
      expect(subject).to permit(admin, first_post)
    end
    
    it 'denies access to published post' do
      expect(subject).not_to permit(guest_writer, published_post)
    end
  end

  permissions :publish? do
    it 'grants access to user who created the post' do
      expect(subject).to permit(guest_writer, completed_post)
    end

    it 'denies access to user who did not created the post' do
      expect(subject).not_to permit(guest_writer, second_post)
    end

    it 'grants all access to admin' do
      expect(subject).to permit(admin, first_post)
    end
    
    it 'denies access to draft post' do
      expect(subject).not_to permit(guest_writer, first_post)
    end
  end

end
