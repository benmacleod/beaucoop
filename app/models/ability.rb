class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :read, Book
    if user.admin?
      can :manage, :all
    elsif user.persisted?
      can :manage, Book, user_id: user.id
      can :read, Book
    end
  end
end
