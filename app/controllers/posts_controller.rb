class PostsController < ApplicationController
  before_action :find_post, only: %i[show edit draft publish update destroy]

  def index
    @posts = policy_scope(Post).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(posts_params.merge(user: current_user))
    render :new, status: :unprocessable_entity and return unless @post.save

    params[:post][:tags].split(',').map(&:strip).each do |tag|
      @post.tags.find_or_create_by!(name: tag)
    end
    redirect_to({ action: :show, slug: @post.slug }, notice: 'Post saved as draft.')
  end

  def show; end

  def edit; end

  def update
    render :edit, status: :unprocessable_entity and return unless @post.update(posts_params)

    updated_tags = params[:post][:tags].split(',').map(&:strip)
    removed_tags = @post.tags.where('name not in (?)', updated_tags)
    @post.tags.delete(*removed_tags)
    params[:post][:tags].split(',').map(&:strip).each do |tag|
      tag_obj = Tag.find_or_create_by!(name: tag)
      @post.tags << tag_obj unless @post.tags.exists?(tag_obj.id)
    end
    redirect_to({ action: :show, slug: @post.slug }, notice: 'Post updated.') 
  end

  def destroy
    @post.destroy
    flash[:notice] = 'Post deleted.'
    redirect_to posts_path
  end

  def draft
    @post.toggle!(:draft)

    redirect_to post_path(@post)
  end

  def publish
    @post.toggle!(:is_private)
    @post.update(published_at: Time.now) if !@post.is_private

    redirect_to post_path(@post)
  end

  private

  def posts_params
    params.require(:post).permit(:title, :content, :slug, :is_private, :draft, :short_description)
  end

  def find_post
    @post = Post.find_by(slug: params[:slug]) || Post.find(params[:id])
    authorize @post

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    redirect_to(posts_path, alert: 'Invalid Post Address. This post cannot be found.') and return false
  end
end
