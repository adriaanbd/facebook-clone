require 'rails_helper'

RSpec.describe Requests::SentRequestsController, type: :controller do

	describe 'GET index' do
		let(:a_user) { FactoryBot.create(:user) }
		context 'when user is logged in' do 

      before do 
        sign_in a_user
        get :index
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

      it 'renders :index template' do
        expect(response).to render_template(:index)
      end 
    end

    context 'when user is NOT logged in' do 

      before do 
        get :index
      end

      it 'responds succesfully' do 
        expect(response).to_not be_successful
      end

      it 'responds with 302' do
        expect(response).to have_http_status '302'
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_path)
      end 
    end

  end

end
