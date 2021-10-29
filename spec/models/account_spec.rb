# == Schema Information
#
# Table name: accounts
#
#  id                 :bigint           not null, primary key
#  status             :integer          default("trial"), not null
#  trial_end_date     :datetime         not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  stripe_customer_id :string
#  user_id            :bigint           not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:account)).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
