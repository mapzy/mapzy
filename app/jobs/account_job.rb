# frozen_string_literal: true

class AccountJob < ApplicationJob
  def perform(user_id)
    account = Account.find_by(user_id: user_id)
    account.update(status: "inactive") if account.trial?
  end
end
