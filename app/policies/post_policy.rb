class PostPolicy < ApplicationPolicy

  # admin can do whatever he wants
  # users should only be able to comment
  # guest_writer should only do whatever he wants with his posts

  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  class Scope < ApplicationPolicy::Scope
    attr_reader :user, :scope 
    
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user&.is_admin?
        scope.all
      elsif user&.is_guest_writer?
        scope.where(user:)
      else
        scope.where(is_private: false)
      end
    end
  end

  def new?
    create?
  end

  def create?
    user&.is_admin? || user&.is_guest_writer?
  end

  def show?
    user&.is_admin? || !post.is_private? || post&.user_id == user&.id
  end

  def edit?
    update?
  end

  def update?
    user&.is_admin? || (post&.user_id == user&.id && user&.is_guest_writer?) && post.is_private && post.draft
  end

  def destroy?
    user&.is_admin? || (post&.user_id == user&.id && user&.is_guest_writer?) && post.is_private
  end

  def draft?
    destroy?
  end

  def publish?
    user&.is_admin? || (post&.user_id == user&.id && user&.is_guest_writer?) && !post.draft
  end
end
