require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:a_user) { FactoryBot.create(:user) }
  let(:active_friend) { FactoryBot.create(:user) }
  let(:friend_request) { FactoryBot.build(:friend_request, requester: active_friend, requestee: a_user)}
  let(:stranger) { FactoryBot.create(:user) }
  let(:befriended) { FactoryBot.build(:friendship, active_friend: active_friend, passive_friend: a_user) }


  describe 'POST create' do

    context 'when logged in' do 

      before do 
        sign_in a_user
        friend_request.save!
      end

      context 'when authorised' do 
        it 'adds friendship to active friend' do
          expect { post :create, params: { active_friend_id: active_friend.id } }.to change(active_friend.active_friends, :count).by(1)
        end

        it 'adds friendship to passive friend' do
          expect { post :create, params: { active_friend_id: active_friend.id } }.to change(a_user.passive_friends, :count).by(1)
        end
      end
    end

    context 'when not logged in' do 
      it 'does not add a friendship' do
        expect { post :create, params: { active_friend_id: active_friend.id } }.to_not change(active_friend.active_friends, :count)
      end
    end
  end

  describe 'DELETE destroy' do

    context 'when logged in' do 

        before do 
          sign_in a_user
          befriended.save
        end

      context 'when authorised' do 

        it 'destroys friendship to active friend' do
          expect { delete :destroy, params: { id: befriended.id } }.to change(active_friend.active_friends, :count).by(-1)
        end

        it 'destroys friendship to passive friend' do
          expect { delete :destroy, params: { id: befriended.id } }.to change(a_user.passive_friends, :count).by(-1)
        end
      end
    end

    context 'when not logged in' do 
      it 'does not destroy friendship of active_friend' do
        befriended.save
        expect { delete :destroy, params: { id: befriended.id } }.to_not change(active_friend.active_friends, :count)
      end

      it 'does not destroy friendship of passive_friend' do
        befriended.save
        expect { delete :destroy, params: { id: befriended.id } }.to_not change(a_user.passive_friends, :count)
      end
    end
  end
end

