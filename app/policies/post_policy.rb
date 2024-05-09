class PostPolicy < ApplicationPolicy

  # admin can do whatever he wants
  # users should only be able to comment
  # guest_writer should only do whatever he wants with his posts


  class Scope < ApplicationPolicy::Scope
    def resolve
      if @user&.is_admin?
        scope.all
      elsif @user&.is_guest_writer?
        scope.where(user: @user)
      else
        scope.where(is_private: false)
      end
    end
  end

  # def index?
  #   user&.is_admin?
  # end

  # def new?
  #   user.is_admin?
  # end

  # def create?
  #   user.is_admin?
  # end

  # def edit?
  #   user.is_admin?
  # end

  # def update?
  #   user.is_admin?
  # end

  # def destroy?
  #   user.is_admin?
  # end
end
