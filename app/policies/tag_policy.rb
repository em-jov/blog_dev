class TagPolicy < ApplicationPolicy
  attr_reader :user, :tag

  def initialize(user, tag)
    @user = user
    @tag = tag
  end

  class Scope < ApplicationPolicy::Scope
    attr_reader :user, :scope 
    
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user&.is_admin?
        scope.posts.all
      elsif user&.is_guest_writer?
        scope.posts.where(user:).or(scope.posts.where(is_private: false))   
      else
        scope.posts.where(is_private: false)
      end
    end
  end

  def show?
    true
  end

  def edit?
    update?
  end

  def update?
    user&.is_admin?
  end

  def destroy?
    user&.is_admin?
  end

end