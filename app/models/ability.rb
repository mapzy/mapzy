# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :manage, Map, user: user
    can :manage, Location, map: { user: user }
    can :manage, Account, user: user
  end
end
