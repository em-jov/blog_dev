class Post < ApplicationRecord
  def to_param
    slug
  end

  def create_slug
    return self.name.parameterize
  end
  
  validates :slug, 
    presence: true, 
    uniqueness: true, 
    length: {minimum: 2, maximum: 30}
end
