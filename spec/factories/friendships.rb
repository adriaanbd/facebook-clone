# == Schema Information
#
# Table name: friendships
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  active_friend_id  :integer
#  passive_friend_id :integer
#
# Indexes
#
#  index_friendships_on_active_friend_id                        (active_friend_id)
#  index_friendships_on_active_friend_id_and_passive_friend_id  (active_friend_id,passive_friend_id) UNIQUE
#  index_friendships_on_passive_friend_id                       (passive_friend_id)
#

FactoryBot.define do
  factory :friendship do
    association :active_friend
    association :passive_friend

    factory :legal_friendship do 
      active_friend { FactoryBot.create(:user) }
      passive_friend { FactoryBot.create(:user) }
    end

    factory :ilegal_friendship do 
      active_friend { Friendship.first.passive_friend }
      passive_friend { Friendship.first.active_friend }      
    end
  end
end
