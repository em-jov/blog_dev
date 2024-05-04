class PostsController < ApplicationController
  before_action :find_post, only: %i[show edit draft private update]
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def show; end

  def create
    @post = Post.create(posts_params)
    redirect_to(posts_path, notice: 'Post saved as draft.') and return if @post.save

    render :new, status: :unprocessable_entity
  end

  def edit; end

  def draft
    @post.toggle!(:draft)

    redirect_to post_path(id: @post.id)
  end

  def private
    @post.toggle!(:private)

    redirect_to post_path(id: @post.id)
  end

  def update
    redirect_to(post_path(id: @post.id), notice: 'Post updated.') and return if @post.update(posts_params)

    render :new, status: :unprocessable_entity
  end

  private

  def posts_params
    params.require(:post).permit(:title, :content, :slug, :private, :draft, :short_description)
  end

  def find_post
    @post = Post.find(params[:id])
    return if @post

    flash[:alert] = "Invalid Post Address. This post cannot be found."
    redirect_to posts_path and return
  end
end
