# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmailWorker, type: :worker do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }

  describe "perform" do
    shared_context "with successful email" do |email_name|
      before do
        ActionMailer::Base.deliveries = []
        account.update(status: "trial")
        subject.perform(email_name, user.id)
        @mail = ActionMailer::Base.deliveries.last
      end
    end

    shared_examples "a correct address email" do |_mail|
      it "sends out email to correct address" do
        expect(@mail.to.first).to eq(user.email)
      end
    end

    shared_examples "a correct subject email" do |_mail, email_subject|
      it "sends out email with correct subject" do
        expect(@mail.subject).to eq(email_subject)
      end
    end

    context "with reminder_email1" do
      include_context "with successful email", "reminder_email1"
      it_behaves_like "a correct address email", @mail
      it_behaves_like "a correct subject email", @mail, "Your Mapzy trial ends in 7 days"
    end

    context "with reminder_email2" do
      include_context "with successful email", "reminder_email2"
      it_behaves_like "a correct address email", @mail
      it_behaves_like "a correct subject email", @mail, "Your Mapzy trial ends tomorrow"
    end

    context "with account_inactivated_email" do
      include_context "with successful email", "account_inactivated_email"
      it_behaves_like "a correct address email", @mail
      it_behaves_like "a correct subject email", @mail, "Your Mapzy trial is over"
    end

    context "with reminder_email1 but active account" do
      before do
        ActionMailer::Base.deliveries = []
        account.update(status: "active")
        subject.perform("reminder_email1", user.id)
        @mail = ActionMailer::Base.deliveries.last
      end

      it "won't send an email" do
        expect(ActionMailer::Base.deliveries.length).to eq(0)
      end
    end
  end
end
