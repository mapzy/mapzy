# frozen_string_literal: true

require "rails_helper"

RSpec.describe AccountMailer, type: :mailer do
  describe "welcome_email" do
    let(:user) { create(:user) }

    shared_examples "a correct email" do |email_subject,body|
      it "renders the subject" do
        expect(mail.subject).to eq(email_subject)
      end

      it "renders the to" do
        expect(mail.to).to eq([user.email])
      end

      it "renders the from" do
        expect(mail.from).to eq(["bonjour@mapzy.io"])
      end
  
      it "renders the body" do
        expect(mail.body.encoded).to match(body)
      end
    end

    context "with welcome_email" do
      let(:mail) { AccountMailer.with(email: user.email).welcome_email }
      it_behaves_like(
        "a correct email",
        "Welcome to Mapzy 👋",
        "Welcome to Mapzy!"
      )
    end

    context "with reminder_email1" do
      let(:mail) { AccountMailer.with(email: user.email).reminder_email1 }
      it_behaves_like(
        "a correct email",
        "Your Mapzy trial ends in 7 days",
        "Here's a quick reminder that your trial ends in 7 days"
      )
    end

    context "with reminder_email2" do
      let(:mail) { AccountMailer.with(email: user.email).reminder_email2 }
      it_behaves_like(
        "a correct email",
        "Your Mapzy trial ends tomorrow",
        "Here's a quick reminder that your trial ends <b>tomorrow</b>"
      )
    end

    context "with account_inactivated_email" do
      let(:mail) { AccountMailer.with(email: user.email).account_inactivated_email }
      it_behaves_like(
        "a correct email",
        "Your Mapzy trial is over",
        "Your trial is over and we have deactivated your account"
      )
    end
  end
end
