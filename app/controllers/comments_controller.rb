class CommentsController < ApplicationController
  before_action :find_post

  def index
    @post.comments.order(created_at: :desc)
  end

  def new
    @comment = @post.comments.new
  end

  def create
    @comment = @post.comments.new(comments_params.merge(user: current_user))
    @comment.valid?
    Rails.logger.error(@comment.errors)
    render :new, status: :unprocessable_entity and return unless @comment.save

    redirect_to({ controller: :posts, action: :show, slug: @post.slug }, notice: 'Comment added.')
  end

  private

  def comments_params
    params.require(:comment).permit(:content)
  end

  def find_post
    @post = Post.find_by(slug: params[:post_slug])
  end
end