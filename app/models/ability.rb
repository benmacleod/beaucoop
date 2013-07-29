class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :welcome, :all
    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end
  end
end
