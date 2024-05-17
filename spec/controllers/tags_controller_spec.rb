require 'rails_helper'

RSpec.describe TagsController do
  let(:admin) { User.create(email: 'user@mail.com', role: 1) }
  let(:post) { Post.create(title: 'first post', short_description: 'Short desc.', user_id: admin.id) }
  let(:tag) { Tag.create(name: 'first tag') }

  describe '#index' do
    it 'renders page' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    it 'renders page' do
      get :show, params: { slug: tag.slug }
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#edit' do
    it 'renders form' do
      get :edit, params: { slug: tag.slug}
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    it 'updates a tag' do
      put :update, params: { slug: tag.slug, tag: { name: 'second tag' } }
      tag.reload
      expect(tag.name).to eq('second tag')
    end

    it 'fails to update a tag' do
      put :update, params: {  slug: tag.slug, tag: { slug: nil } }
      tag.reload
      expect(tag.slug).to_not be_nil
    end
  end

  describe '#destroy' do
    it 'deletes a tag' do
      pp tag
      delete :destroy, params: { slug: tag.slug }
      expect(Tag.count).to eq(0)
    end
  end

  #failing: nil problem
  describe 'before_actions' do
    it 'redirects to index with alert if tag is not found' do
      delete :destroy, params: { slug: "" }
      expect(flash[:alert]).to eq("Invalid Tag. This tag cannot be found.")
      expect(response).to redirect_to(tags_path)
    end
  end

end