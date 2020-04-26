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

class Friendship < ApplicationRecord
	validates :active_friend_id, presence: true
	validates :passive_friend_id, presence: true
  validate :friendship_validation

	belongs_to :active_friend, class_name: 'User'
	belongs_to :passive_friend, class_name: 'User'

	def friendship_validation
	  if (Friendship.where(active_friend_id: active_friend_id, passive_friend_id: passive_friend_id).exists? || Friendship.where(active_friend_id: passive_friend_id, passive_friend_id: active_friend_id).exists?)
	    self.errors.add(:unique_friendship, 'Already friends!')

	  elsif active_friend_id == passive_friend_id
	  	self.errors.add(:invalid_friendship, 'Cannot befriend self')
	  end
	end
end
