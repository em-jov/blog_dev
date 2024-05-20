class TagsController < ApplicationController
  before_action :find_tag, only: %i[show edit update destroy]

  def index
    @tags = Tag.all
  end

  def show; end

  def edit; end

  def update
    redirect_to({ action: :show, slug: @tag.slug }, notice: 'Tag updated.') and return if @tag.update(tags_params)

    render :edit, status: :unprocessable_entity
  end

  def destroy    
    @tag.destroy
    flash[:notice] = 'Tag deleted'
    redirect_to tags_path
  end

  private

  def tags_params
    params.require(:tag).permit(:name, :slug)
  end

  def find_tag
    @tag = Tag.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound if @tag.nil?
    authorize @tag

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    redirect_to(tags_path, alert: 'Invalid Tag. This tag cannot be found.') and return false
  end

end