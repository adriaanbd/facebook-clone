# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  notifiable_type :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :bigint
#  user_id         :integer
#
# Indexes
#
#  index_notifications_on_notifiable_type_and_notifiable_id  (notifiable_type,notifiable_id)
#  index_notifications_on_user_id                            (user_id)
#

FactoryBot.define do
  factory :notification do
    status { "Unread" }
    
    trait :for_like do 
      association :notifiable, factory: :like
      association :user, factory: :user
      status { "Unread" }
    end

    trait :for_comment do 
      association :notifiable, factory: :comment
      association :user, factory: :user
      status { "Read" }
    end
  end
end
