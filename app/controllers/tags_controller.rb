class TagsController < ApplicationController
  before_action :find_tag, only: %i[show]

  def index
    @tags = Tag.all
  end

  def show; end

  private

  def find_tag
    @tag = Tag.find_by(slug: params[:slug])
  end

  def tags_params
    params.require(:tag).permit(:name, :slug)
  end
end