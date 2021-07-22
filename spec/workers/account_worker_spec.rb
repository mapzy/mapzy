# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountWorker, type: :worker do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }

  describe "perform" do
    context "with account.status == trial" do
      before do
        account.update(status: "trial")
        subject.perform(user.id)
      end

      it "sets account.status to 'inactive'" do
        expect(Account.find(account.id).status).to eq("inactive")
      end
    end

    context "with account.status == active" do
      before do
        account.update(status: "active")
        subject.perform(user.id)
      end

      it "keeps account.status == active" do
        expect(Account.find(account.id).status).to eq("active")
      end
    end
  end
end
