class Post < ApplicationRecord
  before_validation :create_slug, on: :create
  has_rich_text :content
  
  def to_param
    slug
  end

  validates :title, :slug, presence: true, uniqueness: true
  validates :short_description, presence: true
  
  private

  def create_slug
    return if self.title.nil?
    
    slug = self.title.parameterize
    if Post.find_by(slug: slug)
      self.slug = slug + "-" + SecureRandom.hex(6)
    else
      self.slug = slug
    end
  end
end
 