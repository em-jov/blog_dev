class PostsController < ApplicationController
  before_action :find_post, only: %i[show edit draft publish update destroy]
  def index
    @posts = Post.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def show; end

  def create
    @post = Post.new(posts_params)
    redirect_to(post_path(slug: @post.slug), notice: 'Post saved as draft.') and return if @post.save

    render :new, status: :unprocessable_entity
  end

  def edit; end

  def draft
    @post.toggle!(:draft)

    redirect_to post_path(slug: @post.slug)
  end

  def publish
    @post.toggle!(:private)

    redirect_to post_path(slug: @post.slug)
  end

  def update
    redirect_to(post_path(slug: @post.slug), notice: 'Post updated.') and return if @post.update(posts_params)

    render :new, status: :unprocessable_entity
  end

  def destroy
    @post.destroy
    flash[:notice] = 'Post deleted.'
    redirect_to posts_path
  end

  private

  def posts_params
    params.require(:post).permit(:title, :content, :slug, :private, :draft, :short_description)
  end

  def find_post
    @post = Post.find_by(slug: params[:slug])
    return if @post

    flash[:alert] = "Invalid Post Address. This post cannot be found."
    redirect_to posts_path and return
  end
end
