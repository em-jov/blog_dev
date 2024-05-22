require 'rails_helper'

RSpec.describe TagPolicy, type: :policy do
  let(:admin) { User.create(email: 'admin@mail.com', role: :admin) }
  let(:guest_writer) { User.create(email: 'guest_writer@mail.com', role: :guest_writer) }
  let(:user) { User.create(email: 'user@mail.com', role: :user) }
  let(:first_post) { Post.create(title: 'first post', short_description: 'short desc', user_id: guest_writer.id)}
  let(:second_post) { Post.create(title: 'second post', short_description: 'short desc', is_private: false, user_id: admin.id)}
  let(:first_tag) { Tag.create(name: 'first tag') }
  let(:scope_admin) { Pundit.policy_scope!(admin, first_tag) } 
  let(:scope_guest_writer) { Pundit.policy_scope!(guest_writer, first_tag) } 
  let(:scope_user) { Pundit.policy_scope!(user, first_tag) } 

  subject { described_class }

  permissions ".scope" do
    before do
      first_post.tags << first_tag
      second_post.tags << first_tag
    end

    it 'grants admin access to all the tag posts' do
      expect(scope_admin.to_a).to match_array([first_post, second_post])
    end

    it 'grants guest writer access to tag published posts or ones created by them' do
      expect(scope_guest_writer.to_a).to match_array([first_post, second_post])
    end

    it 'grants all users access to published posts only' do
      expect(scope_user.to_a).to match_array([second_post])
    end
  end  

  permissions :show? do
    it 'grants all access' do
      expect(subject).to permit(admin, first_tag)
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