require 'rails_helper'

RSpec.describe FriendsController, type: :controller do
  let(:a_user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:stranger) { FactoryBot.create(:user) }
  let(:friendship) { FactoryBot.create(:friendship, active_friend: a_user, passive_friend: other_user) }

  describe 'GET index' do 
    context 'when logged in' do 
      

      context 'when authorised' do 

        before do 
          sign_in a_user
          get :index, params: { username: a_user.username }
        end
        
        it 'responds succesfully' do 
          expect(response).to be_successful
        end

        it 'responds with 200' do 
          expect(response).to have_http_status('200')
        end

        it 'renders :index' do 
          expect(response).to render_template(:index)
        end
      end

      context 'when not authorised' do 
        before do 
          sign_in stranger
          get :index, params: { username: a_user.username }
        end

        it 'redirects to profile_path' do 
          expect(response).to redirect_to(profile_path(a_user.username))
        end
      end
    end

    context 'when not logged in' do 
      before do 
        get :index, params: { username: a_user.username }
      end
      it 'redirects to profile_path' do 
        expect(response).to redirect_to(profile_path(a_user.username))
      end
    end
  end
end
