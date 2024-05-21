class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_rich_text :content
end
