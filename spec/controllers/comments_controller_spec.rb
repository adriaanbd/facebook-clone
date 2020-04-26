require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:stranger) { FactoryBot.create(:user) }
  let!(:commented_post) { FactoryBot.create(:post, user: user) }
  let!(:comment) { FactoryBot.create(:comment, post_id: commented_post.id, user_id: user.id) }

  # build
  let(:deleted_comment) { FactoryBot.build(:comment, post_id: commented_post.id, user_id: user.id) }

  describe 'GET edit' do 

    context 'when user is logged in' do 


      context 'when authorised' do 

        before do 
          sign_in user 
          get :edit, params: { username: user.username, post_id: commented_post.id, id: comment.id }  
        end

        it 'responds http status 2xx' do 
          expect(response).to have_http_status(:success)
        end

        it 'responds http status 200' do 
          expect(response).to have_http_status(:ok)
        end

        it 'renders :edit' do 
          expect(response).to render_template(:edit)
        end
      end


      context 'when not authorised' do 
        before do
          sign_in stranger 
          get :edit, params: { username: user.username, post_id: commented_post.id, id: comment.id } 
        end

        it 'responds http status 401 unauthorised' do 
          expect(response).to_not have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'PATCH update' do
    let(:new_msg) { 'Hello Rspec!' }

    context 'when logged in' do 

      before do
        sign_in user 
      end

      context 'when authorised' do
        before do
          sign_in user 
          comment_params = FactoryBot.attributes_for(:comment, message: new_msg)
          patch :update, params: {username: user.username, post_id: commented_post.id, id: comment.id, comment: comment_params }
        end   

        it 'updates message succesfully' do 
          expect(comment.reload.message).to eq(new_msg)
        end
      end

      context 'when not authorised' do
        before do
          sign_in stranger 
          comment_params = FactoryBot.attributes_for(:comment, message: new_msg)
          patch :update, params: {username: user.username, post_id: commented_post.id, id: comment.id, comment: comment_params }
        end   

        it 'responds http status 401 unauthorised' do 
          expect(response).to_not have_http_status(:unauthorized)
        end

        it 'does not update message' do 
          expect(comment.reload.message).to_not eq(new_msg)
        end
      end
    end

    context 'when not logged in' do 
      it 'does not update message' do 
        comment_params = FactoryBot.attributes_for(:comment, message: new_msg)
        patch :update, params: {username: user.username, post_id: commented_post.id, id: comment.id, comment: comment_params }
        expect(comment.reload.message).to_not eq(new_msg)
      end
    end
  end

  describe 'POST create' do 
    let(:new_msg) { 'Hello Rspec!' }

    context 'when user is logged in' do

      before do 
        sign_in user
      end

      context 'when authorised' do 

        it 'redirects to creation page when successfully create post comment' do 
          comment_params = FactoryBot.attributes_for(:comment)
          post :create, params: {username: user.username, post_id: commented_post.id, comment: comment_params }
          expect(response).to have_http_status(:redirect)
        end

        it 'creates a post comment' do 
          comment_params = FactoryBot.attributes_for(:comment)
          expect { post :create, params: {username: user.username, post_id: commented_post.id, comment: comment_params } }.to change(commented_post.comments, :count).by(1)
        end

        it 'creates associated notification' do 
          comment_params = FactoryBot.attributes_for(:comment)
          expect { post :create, params: {username: user.username, post_id: commented_post.id, comment: comment_params } }.to change(Notification, :count).by(1)
        end
      end
    end

    context 'when user is logged out' do 

      it 'does not create a post comment' do 
        expect { post :create, params: { username: user.username, post_id: commented_post.id } }.to_not change(commented_post.comments, :count)
      end
    end

  end

  describe 'DELETE destroy' do 

    context 'when user is logged in' do

      before do 
        deleted_comment.save
      end

      context 'when authorised' do 
        it 'destroys a post comment' do 
          sign_in user
          expect { delete :destroy,
            params: { username: user.username, post_id: commented_post.id, id: deleted_comment.id }
          }.to change(commented_post.comments, :count).by(-1)
        end

        it 'destroys associated notification' do 
          sign_in user
          expect { delete :destroy, params: { username: user.username, post_id: commented_post.id, id: deleted_comment.id } }.to change(Notification, :count).by(-1)
        end
      end

      context 'when not authorised' do 
        it 'does not destroy a like if not like owner' do 
          sign_in stranger
          expect { delete :destroy,
            params: { username: user.username, post_id: commented_post.id, id: deleted_comment.id }
          }.to_not change(commented_post.comments, :count)
        end
      end
    end

    context 'when user is logged out' do 
      
      before do 
        deleted_comment.save
      end

      it 'does not destroy a like' do 
        expect { delete :destroy,
          params: { username: user.username, post_id: commented_post.id, id: deleted_comment.id }
        }.to_not change(commented_post.comments, :count)
      end
    end
  end
end
