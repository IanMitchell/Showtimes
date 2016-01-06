module ApplicationHelper
  def user_is_admin?
    current_user&.members&.where(role: 2).present?
  end
end
