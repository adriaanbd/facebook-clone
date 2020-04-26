# == Schema Information
#
# Table name: friend_requests
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  requestee_id :integer
#  requester_id :integer
#
# Indexes
#
#  index_friend_requests_on_requestee_id                   (requestee_id)
#  index_friend_requests_on_requester_id                   (requester_id)
#  index_friend_requests_on_requester_id_and_requestee_id  (requester_id,requestee_id) UNIQUE
#

FactoryBot.define do
  factory :friend_request do
    association :requester
    association :requestee

    factory :legal_friend_request do 
      requester { FactoryBot.create(:user) }
      requestee { FactoryBot.create(:user) }
    end

    factory :ilegal_friend_request do 
      requester { FriendRequest.first.requestee }
      requestee { FriendRequest.first.requester }      
    end
  end
end
