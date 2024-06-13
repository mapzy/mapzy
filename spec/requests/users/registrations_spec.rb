# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :request do
  describe "POST create" do
    let(:user) { build(:user) }

    let(:user_params) do
      {
        user: {
          email: user.email,
          password: user.password,
          password_confirmation: user.password
        }
      }
    end

    before do
      @mapzy_cloud_env_before = ENV["MAPZY_CLOUD"]
      ENV["MAPZY_CLOUD"] = "true"
    end

    after do
      ENV["MAPZY_CLOUD"] = @mapzy_cloud_env_before # rubocop:disable RSpec/InstanceVariable
    end

    context "with valid user" do
      it "responds with a HTTP 302" do
        post user_registration_path(params: user_params)
        expect(response).to redirect_to(root_path)
      end

      it "creates the correct user" do
        post user_registration_path(params: user_params)
        expect(User.where(email: user.email)).to exist
      end

      it "creates an account for the user" do
        post user_registration_path(params: user_params)
        new_user = User.find_by(email: user.email)
        expect(Account.where(user: new_user)).to exist
      end

      it "sends welcome email" do
        expect do
          post user_registration_path(params: user_params)
        end.to have_enqueued_mail(AccountMailer, :welcome_email)
      end

      it "enqueues correct jobs" do
        expect do
          post user_registration_path(params: user_params)
        end.to have_enqueued_job(EmailJob).exactly(3).times
      end
    end

    context "with unmatching passwords" do
      it "responds with a HTTP 302" do
        post user_registration_path(params: user_params)
        expect(response).to redirect_to(root_path)
      end

      it "doesn't create a user" do
        user_params[:user][:password] = "123456"
        user_params[:user][:password_confirmation] = "654321"
        post user_registration_path(params: user_params)
        expect(User.where(email: user.email)).not_to exist
      end
    end
  end

  describe "PATCH update" do
    let(:user) { create(:user) }

    let(:user_params) do
      {
        user: {
          email: user.email,
          current_password: user.password
        }
      }
    end

    before { sign_in user }

    context "with valid form and new email" do
      let(:new_email) { "ghost@mapzy.io" }

      before do
        user_params[:user][:email] = new_email
        patch user_registration_path(params: user_params)
      end

      it "responds with the correct redirect" do
        expect(response).to redirect_to dashboard_account_settings_path
      end

      it "updated the data correctly" do
        expect(User.find(user.id).email).to eq(new_email)
      end
    end

    context "with invalid password" do
      before do
        user_params[:user][:current_password] = "abc123xyz"
        patch user_registration_path(params: user_params)
      end

      it "show correct error message in HTML" do
        expect(response.body).to include("Current password is invalid")
      end
    end

    context "with invalid email" do
      let(:user2) { create(:user) }

      before do
        user_params[:user][:email] = user2.email
        patch user_registration_path(params: user_params)
      end

      it "show correct error message in HTML" do
        expect(response.body).to include("Email has already been taken")
      end

      it "didn't update the data" do
        expect(User.find(user.id).email).not_to eq(user2.email)
      end
    end

    context "with not matching passwords" do
      before do
        user_params[:user][:password] = "123456"
        user_params[:user][:password_confirmation] = "654321"
        patch user_registration_path(params: user_params)
      end

      it "show correct error message in HTML" do
        expect(response.body).to include("Password confirmation doesn't match Password")
      end
    end
  end
end
