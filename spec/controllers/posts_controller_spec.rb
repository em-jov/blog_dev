require 'rails_helper'

RSpec.describe PostsController do
  let(:post) { Post.create(title: 'first post', short_description: 'Short desc.')}
  let(:post_build) { Post.build(title: 'second post', short_description: 'Shorter desc.')}

  describe '#index' do
    it 'renders page' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it 'renders form' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    it 'creates new post' do
      put :create, params: { post: { title: post_build.title, short_description: post_build.short_description } }
      new_post = Post.last
      expect(new_post).to have_attributes(title: post_build.title, short_description: post_build.short_description)
    end

    it 'redirects to posts page' do
      put :create, params: { post: { title: post_build.title, short_description: post_build.short_description } }
      new_post = Post.last
      expect(response).to redirect_to post_path(slug: new_post.slug)
    end

    it 'fails to create new post' do
      put :create, params: { post: { title: nil, short_description: post_build.short_description } }
      expect(Post.count).to eq(0)
    end
  end

  describe '#show' do
    it 'renders page' do
      get :show, params: { slug: post.slug }
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#edit' do
    it 'renders form' do
      get :edit, params: { slug: post.slug }
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    it 'updates a post' do
      put :update, params: { slug: post.slug, post: { title: "new-title" } }
      post.reload
      expect(post.title).to eq("new-title")
    end

    it 'fails to update a post' do
      put :update, params: { slug: post.slug, post: { slug: nil } }
      post.reload
      expect(post.slug).to_not be_nil
    end
  end

  describe '#destroy' do
    it 'deletes a post' do
      delete :destroy, params: { slug: post.slug }
      expect(Post.count).to eq(0)
    end
  end

  describe '#publish' do
    it 'publishes a post' do
      post.update(is_private: true)
      patch :publish, params: { slug: post.slug, post: { is_private: post.is_private } }
      post.reload
      expect(post.is_private).to eq(false)
    end

    it 'makes post private' do
      post.update(is_private: false)
      patch :publish, params: { slug: post.slug, post: { is_private: post.is_private } }
      post.reload
      expect(post.is_private).to eq(true)
    end
  end

  describe '#draft' do
    it 'marks post as completed' do
      post.update(draft: true)
      patch :draft, params: { slug: post.slug, post: { draft: post.draft } }
      post.reload
      expect(post.draft).to eq(false)
    end

    it 'marks post as draft' do
      post.update(draft: false)
      patch :draft, params: { slug: post.slug, post: { draft: post.draft } }
      post.reload
      expect(post.draft).to eq(true)
    end
  end

  describe 'before_actions' do
    it 'redirects to index with alert if post is not found' do
      delete :destroy, params: { slug: "" }
      expect(flash[:alert]).to eq("Invalid Post Address. This post cannot be found.")
      expect(response).to redirect_to(posts_path)
    end
  end

end