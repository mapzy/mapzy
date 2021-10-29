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
FactoryBot.define do
  factory :account do
    # trial_end_date is created as a default value in Postgres
    # FactoryBot doesn't pick that up, so we need to specify it here
    trial_end_date { 2.weeks.from_now }
    association :user
  end
end
