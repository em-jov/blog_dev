require 'rails_helper'

RSpec.describe TagPolicy, type: :policy do
  let(:admin) { User.create(email: 'admin@mail.com', role: :admin) }
  let(:guest_writer) { User.create(email: 'guest_writer@mail.com', role: :guest_writer) }
  let(:user) { User.create(email: 'user@mail.com', role: :user) }
  let(:first_post) { Post.create(title: 'first post', short_description: 'short desc', user_id: guest_writer.id)}
  let(:second_post) { Post.create(title: 'second post', short_description: 'short desc', is_private: false, user_id: guest_writer.id)}
  let(:first_tag) { Tag.create(name: 'first tag') }

  subject { described_class }

  permissions :show? do
    context 'when there are public posts associated with the tag' do
      let(:policy) { TagPolicy.new(user, first_tag) }

      before do
        second_post.tags << first_tag
      end

      it 'allows access' do
        expect(policy.show?).to eq([true])
      end
    end

    context 'when there are no public posts associated with the tag' do
      let(:policy) { TagPolicy.new(user, first_tag) }

      before do
        first_post.tags << first_tag
      end

      it 'denies access' do
        expect(policy.show?).to eq([false])
      end
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