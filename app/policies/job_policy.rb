class JobPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.published? || user_is_owner_or_admin?
  end

  def create?
    user.present? && (user.employer.present? || user.admin?)
  end

  def update?
    user_is_owner_or_admin?
  end

  def destroy?
    user_is_owner_or_admin?
  end

  def publish?
    user_is_owner_or_admin? && record.draft?
  end

  def archive?
    user_is_owner_or_admin? && record.published?
  end

  private

  def user_is_owner_or_admin?
    user.present? && (user == record.employer.user || user.admin?)
  end
end
