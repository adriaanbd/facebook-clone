require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  
  let(:a_user) { FactoryBot.create(:user) }
  let(:other) { FactoryBot.create(:user) }
  let(:a_post) { FactoryBot.create(:post, user: a_user) }
  let(:other_post) { FactoryBot.create(:post, user: other) }



  describe 'GET show' do 

    context 'when user is logged in' do 
      
      before do 
        sign_in a_user
        get :show, params: { username: a_user.username, id: a_post.id }
      end

      it 'responds succesfully' do 
        expect(response).to be_successful
      end

      it 'responds with 200' do
        expect(response).to have_http_status '200'
      end

      it 'does not respond with 404' do
        expect(response).to_not have_http_status '404'
      end

      it 'renders :show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'when user is NOT logged in' do 

      before do 
        get :show, params: { username: a_user.username, id: a_post.id }
      end

      it 'redirects to profile_posts_path' do 
        expect(response).to redirect_to(profile_path)
      end
    end
  end

  describe 'GET edit' do 

    context 'when user is logged in' do 
      
      before do 
        sign_in a_user
      end

      context 'when editing his own post' do 
        before do 
          get :edit, params: { username: a_user.username, id: a_post.id }
        end

        it 'responds succesfully' do 
          expect(response).to be_successful
        end

        it 'responds with 200' do
          expect(response).to have_http_status '200'
        end

        it 'does not respond with 404' do
          expect(response).to_not have_http_status '404'
        end

        it 'renders :edit template' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when editing another post' do 
        before do 
          get :edit, params: { username: other.username, id: other_post.id }
        end

        it 'does not respond succesfully' do 
          expect(response).to_not be_successful
        end

        it 'responds with 302' do
          expect(response).to have_http_status '302'
        end

        it 'does not respond with 200' do
          expect(response).to_not have_http_status '200'
        end

        it 'renders profile_post_path' do
          expect(response).to redirect_to(profile_post_path)
        end
      end
    end

    context 'when user is NOT logged in' do 

      before do 
        get :edit, params: { username: a_user.username, id: a_post.id }
      end

      it 'redirects to :index' do 
        expect(response).to redirect_to(profile_path)
      end
    end
  end

  describe 'PATCH update' do
    
    let(:updated_message) { 'lorem ipsum an updated post =)' }


    context 'when authorised user' do
      
      before do 
        sign_in a_user
        post_params = FactoryBot.attributes_for(:post, message: updated_message)
        patch :update, params: { username: a_user.username, id: a_post.id, post: post_params }
      end

      it 'updates message attribute' do
        expect(a_post.reload.message).to eq updated_message
      end

      it 'redirects to profile_posts_path' do
        expect(response).to redirect_to(profile_path)
      end
    end

    context 'when unauthorised user' do 
    
      before do 
        sign_in other
        post_params = FactoryBot.attributes_for(:post, message: updated_message)
        patch :update, params: { username: a_user.username, id: a_post.id, post: post_params }
      end

      it 'does not respond succesfully' do
        expect(response).to_not be_successful
      end

      it 'redirects to profile_posts_path' do
        expect(response).to redirect_to(profile_path)
      end
    end
  end

  describe 'GET new' do

    context 'when logged in' do 
      before do 
         sign_in a_user
         get :new, params: { username: a_user.username }
      end

      it 'responds succesfully' do 
        expect(response).to be_successful
      end

      it 'responds with 200' do 
        expect(response).to have_http_status('200')
      end

      it 'renders new' do 
        expect(response).to render_template(:new)
      end
    end

    context 'when not logged in' do 
      before do 
         get :new, params: { username: a_user.username }
      end

      it 'does not respond succesfully' do 
        expect(response).to_not be_successful
      end

      it 'responds with 302' do 
        expect(response).to have_http_status('302')
      end

      it 'redirects to profile_posts_path' do 
        expect(response).to redirect_to(profile_path)
      end
    end
  end

  describe 'POST create' do
    
    context 'when logged in' do
      before do 
        sign_in a_user
      end 

      context 'when authorised' do 

        it 'creates new post with valid attributes' do
          post_params = FactoryBot.attributes_for(:post, user_id: a_user.id)
          expect { post :create, params: { username: a_user.username, post: post_params } }.to change(a_user.posts, :count).by(1)
        end

        it 'does not create new post with invalid message' do
          post_params = FactoryBot.attributes_for(:post, :invalid, user_id: a_user.id)
          expect { post :create, params: { username: a_user.username, post: post_params } }.to_not change(a_user.posts, :count)
        end

        it 'redirects to profile_posts_path after create' do
          post_params = FactoryBot.attributes_for(:post)
          post :create, params: { username: a_user.username, post: post_params }
          expect(response).to redirect_to(profile_path)
        end
      end

      context 'when not authorised' do 
        it 'does not create new post' do
          post_params = FactoryBot.attributes_for(:post, user_id: other.id)
          expect { post :create, params: { username: other.username, post: post_params } }.to_not change(other.posts, :count)
        end

        it 'redirects to profile_posts_path' do
          post_params = FactoryBot.attributes_for(:post, user_id: other.id)
          post :create, params: { username: other.username, post: post_params }
          expect(response).to redirect_to(profile_path)
        end
      end
    end

    context 'when not logged in' do 
      it 'fails to create new post' do
        post_params = FactoryBot.attributes_for(:post, user_id: a_user.id)
        expect { post :create, params: { username: a_user.username, post: post_params } }.to_not change(a_user.posts, :count)
      end

      it 'responds with 302' do
        post_params = FactoryBot.attributes_for(:post)
        post :create, params: { username: a_user.username, post: post_params }
        expect(response).to have_http_status('302')
      end

      it 'redirects to profile_posts_path' do
        post_params = FactoryBot.attributes_for(:post)
        post :create, params: { username: a_user.username, post: post_params }
        expect(response).to redirect_to(profile_path)
      end
    end
  end

  describe 'DELETE destroy' do

    let!(:other_user) { FactoryBot.create(:user) }
    let!(:one_post) { FactoryBot.create(:post, user: other_user) }
    let!(:another_user) { FactoryBot.create(:user) }
    let!(:deleted_post) { FactoryBot.create(:post, user: another_user) }

    context 'when logged in' do
      before do 
        sign_in other_user
      end 
    
      context 'as an authorized user' do

        it 'deletes the post' do
          expect { delete :destroy, params: { username: other_user.username, id: one_post.id } }.to change(other_user.posts, :count).by(-1)
        end

        it 'redirects to profile_posts_path' do
          delete :destroy, params: { username: other_user.username, id: one_post.id }
          expect(response).to redirect_to(profile_path)
        end
      end

      context 'as an unauthorized user' do
        it 'does not delete the post' do
          expect { delete :destroy, params: {username: another_user.username, id: deleted_post.id } }.to_not change(another_user.posts, :count)
        end
      end
    end

    context 'when not logged in' do
      it 'fails to delete post' do
        post_params = FactoryBot.attributes_for(:post, user_id: a_user.id)
        expect { delete :destroy, params: { username: another_user.username, id: deleted_post.id } }.to_not change(another_user.posts, :count)
      end

      it 'responds with 302' do
        post_params = FactoryBot.attributes_for(:post)
        delete :destroy, params: { username: another_user.username, id: deleted_post.id }
        expect(response).to have_http_status('302')
      end

      it 'redirects to profile_posts_path' do
        post_params = FactoryBot.attributes_for(:post)
        delete :destroy, params: { username: another_user.username, id: deleted_post.id }
        expect(response).to redirect_to(profile_path)
      end
    end
  end
end
