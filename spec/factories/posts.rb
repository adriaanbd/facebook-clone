# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

FactoryBot.define do
  factory :post do
    message { "MyText" }
    association :user

    trait :invalid do
      message { nil }
    end
  end
end
