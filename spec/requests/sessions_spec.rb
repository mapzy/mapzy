require 'rails_helper'

RSpec.describe 'Sessions' do
  let(:user) { User.create }

  it 'signs user in' do
    sign_in user
    get authenticated_root_path
    expect(controller.current_user).to eq(user)
  end

  it 'signs user out' do
    sign_out user
    get authenticated_root_path
    expect(controller.current_user).to be_nil
  end
end
