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

require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
	let(:friend_request) { FactoryBot.build(:friend_request) }

  describe 'test for presense of model attributes' do

    context 'general expected attributes' do
    	it 'should include requester_id attribute' do
    		expect(friend_request.attributes).to include('requester_id')
    	end

      it 'should include requestee_id attribute' do
        expect(friend_request.attributes).to include('requestee_id')
      end
    end

    context 'Rails specific attributes' do
      it 'should include the :created_at attribute' do 
        expect(friend_request.attributes).to include('created_at')
      end

      it 'should include the :updated_at attribute' do 
        expect(friend_request.attributes).to include('updated_at')
      end

      it 'should include the :id attribute' do 
        expect(friend_request.attributes).to include('id')
      end
    end
  end

  describe 'Basic validations' do
    context 'requester_id' do
      it 'is valid with a requester_id' do 
        friend_request.valid?
        expect(friend_request.errors[:requester_id]).to_not include("can't be blank")
      end

      it 'is invalid without a user_id' do 
        friend_request.requester_id = nil
        friend_request.valid?
        expect(friend_request.errors[:requester_id]).to include("can't be blank")
      end
    end

    context 'requestee_id' do
      it 'is valid with a requestee_id' do 
        friend_request.valid?
        expect(friend_request.errors[:requestee_id]).to_not include("can't be blank")
      end

      it 'is invalid without a user_id' do 
        friend_request.requestee_id = nil
        friend_request.valid?
        expect(friend_request.errors[:requestee_id]).to include("can't be blank")
      end
    end
   end
end
