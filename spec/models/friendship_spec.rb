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


require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:friendship) { FactoryBot.create(:friendship) }

  let(:ilegal_friendship) { FactoryBot.build(:ilegal_friendship) }
  let(:legal_friendship) { FactoryBot.build(:legal_friendship) }

  describe 'test for presense of model attributes' do

    context 'general expected attributes' do
      it 'should include active_friend_id attribute' do
        expect(friendship.attributes).to include('active_friend_id')
      end

      it 'should include pasive_friend_id attribute' do
        expect(friendship.attributes).to include('passive_friend_id')
      end
    end
  end

  describe 'Basic validations' do
    context 'requester_id' do
      it 'is valid with a active_friend_id' do 
        friendship.valid?
        expect(friendship.errors[:active_friend_id]).to_not include('can\'t be blank')
      end

      it 'is invalid without a active_friend_id' do 
        friendship.active_friend_id = nil
        friendship.valid?
        expect(friendship.errors[:active_friend_id]).to include('can\'t be blank')
      end
    end

    context 'requestee_id' do
      it 'is valid with a passive_friend_id' do 
        friendship.valid?
        expect(friendship.errors[:passive_friend_id]).to_not include('can\'t be blank')
      end

      it 'is invalid without a passive_friend_id' do 
        friendship.passive_friend_id = nil
        friendship.valid?
        expect(friendship.errors[:passive_friend_id]).to include('can\'t be blank')
      end
    end
   end

   describe 'Unique Constraints' do
    context 'active and passive friend combination should be unique' do
      it 'is not valid when passive and active friend combination isn\'t unique' do
        ilegal_friendship.valid?
        expect(ilegal_friendship.errors[:unique_friendship]).to include('Already friends!')
      end

      it 'is valid when passive and active friend combination is unique' do
        legal_friendship.valid?
        expect(legal_friendship.errors[:unique_friendship]).to_not include('Already friends!')
      end
    end
   end

   describe 'Associations' do
    context 'user' do 
      it 'should belong to requestee' do 
        should belong_to(:passive_friend) 
      end 
      it 'should belong to requester' do 
        should belong_to(:active_friend) 
      end 
    end
  end
end
