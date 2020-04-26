require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do

  let(:user) { FactoryBot.create(:user) }
  let(:other) { FactoryBot.create(:user) }

  describe 'GET show' do 

    context 'when user is logged in' do 

      before do 
        sign_in user
      end

      context 'when viewing his own profile' do 
        it 'responds succesfully' do 
          get :show, params: { username: user.username }
          expect(response).to be_successful
        end

        it 'responds with 200' do
          get :show, params: { username: user.username }
          expect(response).to have_http_status '200'
        end

        it 'does not respond with 404' do
          get :show, params: { username: user.username }
          expect(response).to_not have_http_status '404'
        end

        it 'renders :show template' do
          get :show, params: { username: user.username }
          expect(response).to render_template(:show)
        end 
      end

      context 'when viewing another profile' do
        it 'responds succesfully' do 
          get :show, params: { username: other.username }
          expect(response).to be_successful
        end

        it 'responds with 200' do
          get :show, params: { username: other.username }
          expect(response).to have_http_status '200'
        end

        it 'does not respond with 404' do
          get :show, params: { username: other.username }
          expect(response).to_not have_http_status '404'
        end

        it 'renders :index template' do
          get :show, params: { username: other.username }
          expect(response).to render_template(:show)
        end
      end
    end

    context 'when user is NOT logged in' do 
      context 'when viewing a profile' do 
        it 'responds succesfully' do 
          get :show, params: { username: user.username }
          expect(response).to be_successful
        end

        it 'responds with 200' do
          get :show, params: { username: user.username }
          expect(response).to have_http_status '200'
        end

        it 'does not respond with 404' do
          get :show, params: { username: user.username }
          expect(response).to_not have_http_status '404'
        end

        it 'renders :show template' do
          get :show, params: { username: user.username }
          expect(response).to render_template(:show)
        end 
      end
    end
  end

  describe 'GET edit' do 

    context 'when user is logged in' do

      before do 
        sign_in user
      end

      context 'when editing his own profile' do 
        
        before do
          get :edit, params: { username: user.username }
        end

        it 'responds succesfully' do 
          expect(response).to be_successful
        end

        it 'responds with 200' do 
          expect(response).to have_http_status '200'
        end

        it 'renders :edit template' do 
          expect(response).to render_template(:edit)
        end
      end

      context 'when editing another profile' do
        it 'redirects to profile path' do
          sign_out user
          sign_in other
          get :edit, params: { username: user.username }
          expect(response).to redirect_to(profile_path)
        end
      end
    end

    context 'when user is NOT logged in' do
      it 'redirects to profile_path' do 
        get :edit, params: { username: user.username }
        expect(response).to redirect_to(profile_path)
      end
    end
  end
end
