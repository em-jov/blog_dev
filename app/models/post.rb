class Post < ApplicationRecord
  before_validation :create_slug, on: :create

  def to_param
    slug
  end

  validates :title, presence: true, uniqueness: true
  validates :slug, uniqueness: true
  
  private

  def create_slug
    slug = self.title.parameterize
    if Post.find_by(slug: slug)
      self.slug = slug + "-" + SecureRandom.hex(6)
    else
      self.slug = slug
    end
  end
end
 