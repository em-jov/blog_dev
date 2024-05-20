class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags
  
  has_rich_text :content

  before_validation :create_slug, on: :create

  def to_param
    slug
  end

  validates :title, :slug, presence: true, uniqueness: true
  validates :short_description, presence: true

  def is_public?
    !self.is_private?
  end
  
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
 