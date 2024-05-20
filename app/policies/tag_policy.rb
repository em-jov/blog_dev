class TagPolicy < ApplicationPolicy
  attr_reader :user, :tag

  def initialize(user, tag)
    @user = user
    @tag = tag
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