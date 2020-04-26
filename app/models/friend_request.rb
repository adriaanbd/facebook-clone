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

class FriendRequest < ApplicationRecord
	validates :requester_id, presence: true
	validates :requestee_id, presence: true
  validate :friend_request_validation

	belongs_to :requester, class_name: 'User'
	belongs_to :requestee, class_name: 'User'

  def friend_request_validation
    if (FriendRequest.where(requester_id: requester_id, requestee_id: requestee_id).exists? || FriendRequest.where(requester_id: requestee_id, requestee_id: requester_id).exists?)
      self.errors.add(:unique_friend_request, 'Already requested!')

    elsif requester_id == requestee_id
      self.errors.add(:invalid_friend_request, 'Cannot befriend self')
    end
  end
end
