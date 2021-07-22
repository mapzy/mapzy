# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Map
    can :read, Location

    if user.present?
      can :manage, Map, user_id: user.id

      # TEMP
      can :manage, Location

      # TODO: fix this
      # can :manage, Location, map: { user_id: user.id }

      can :manage, Account
    end
  end
end
