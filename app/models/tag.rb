class Tag < ApplicationRecord
  has_and_belongs_to_many :posts
  before_validation :create_slug, on: :create

  validates :name, :slug, presence: true, uniqueness: true

  private

  def create_slug
    return if self.name.nil?
    
    slug = self.name.parameterize
    if Tag.find_by(slug: slug)
      self.slug = slug + "-" + SecureRandom.hex(6)
    else
      self.slug = slug
    end
  end

end