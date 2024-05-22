class User < ApplicationRecord
  has_many :posts
  has_many :comments
  enum :role, { user: 0, admin: 1, guest_writer: 2 }

  validates :email, presence: true, uniqueness: true

  def is_admin?
    self.admin?
  end

  def is_guest_writer?
    self.guest_writer?
  end
end
