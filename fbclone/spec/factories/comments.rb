# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#

FactoryBot.define do
  factory :comment do
    post_id { 1 }
    user_id { 1 }
    message { "Lorem Ipsum Text" }
  end
end
