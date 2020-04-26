require 'rails_helper'

RSpec.describe FriendRequestsController, type: :controller do
  let(:a_user) { FactoryBot.create(:user) }
  let(:other) { FactoryBot.create(:user) }
  let(:request) { FactoryBot.build(:friend_request, requester: a_user, requestee: other) }
  let(:unauthorized_user) { FactoryBot.create(:user) }


  describe 'POST create' do

    context 'when logged in' do
      before do 
        sign_in a_user
      end 

      context 'when authorised' do
        it 'creates active request with valid attributes' do 
          expect { post :create, params: { username: other.username } }.to change(a_user.sent_requests, :count).by(1)
        end

        it 'does not create request with itself' do
          expect { post :create, params: { username: a_user.username } }.not_to change(a_user.sent_requests, :count)
        end
      end
    end

    context 'when not logged in' do 
      it 'does not create request' do 
        expect { post :create, params: { username: other.username } }.not_to change(a_user.sent_requests, :count)
      end
    end
  end

  describe 'DELETE destroy' do

    context 'when logged in' do

      before do 
        request.save!
      end

      context 'when authorised' do
        it 'deletes request' do 
          sign_in a_user
          expect { delete :destroy, params: { username: a_user.username, id: request.id} }.to change(a_user.sent_requests, :count).by(-1)
        end
      end

      context 'when unauthorised' do 
        it 'does not delete a request' do 
          sign_in unauthorized_user
          expect { delete :destroy, params: { username: a_user.username, id: request.id} }.to change(a_user.sent_requests, :count).by(0)
        end
      end

    end

    context 'when not logged in' do 
      it 'does not delete a request' do 
          request.save!
          sign_in unauthorized_user
          expect { delete :destroy, params: { username: a_user.username, id: request.id} }.to change(a_user.sent_requests, :count).by(0)
      end
    end
  end
end
