# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Map

    if user.present?
      can :manage, Map, user_id: user.id
      can :manage, Location, map: { user_id: user.id }
    end
  end
end
