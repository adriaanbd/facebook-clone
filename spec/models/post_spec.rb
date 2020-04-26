# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Post, type: :model do
	let(:post) { FactoryBot.create(:post) }

	describe 'test for presence of model attributes' do
		context 'general expected attributes' do
			it 'should include user_id attribute' do
    		expect(post.attributes).to include('user_id')
    	end

    	it 'should include message attribute' do
    		expect(post.attributes).to include('message')
    	end
		end

		context 'Rails specific attributes' do
      it 'should include the :created_at attribute' do 
        expect(post.attributes).to include('created_at')
      end

      it 'should include the :updated_at attribute' do 
        expect(post.attributes).to include('updated_at')
      end

      it 'should include the :id attribute' do 
        expect(post.attributes).to include('id')
      end
    end
	end

	 describe 'Basic validations' do
	 	context 'message' do
	 		it 'is valid with a message' do 
        post.valid?
        expect(post.errors[:message]).to_not include("can't be blank")
      end

      it 'is valid if length is less than  50,000 characters' do
        post.valid?
        expect(post.errors[:message]).to_not include('is too long (maximum is 50,000 characters)')
      end

      it 'is invalid if length is more than 50,000 characters' do
        post.message = 'a' * 50001
        post.valid?
        expect(post.errors[:message]).to include('is too long (maximum is 50000 characters)')
      end

      it 'is invalid without a message' do 
        post.message = nil
        post.valid?
        expect(post.errors[:message]).to include("can't be blank")
      end
	 	end

	 	context 'user_id' do
	 		it 'is valid with a user_id' do 
        post.valid?
        expect(post.errors[:user_id]).to_not include("can't be blank")
      end

      it 'is invalid without a user_id' do 
        post.user_id = nil
        post.valid?
        expect(post.errors[:user_id]).to include("can't be blank")
      end
	 	end
  end
  describe 'Associations' do 
    context 'comments' do 
      it 'has correct has_many association' do 
        should have_many(:comments) 
      end
    end 

    context 'likes' do
      it 'has correct has_many association' do 
        should have_many(:likes) 
      end
    end

    context 'user' do 
      it 'has correct belongs_to association' do 
        should belong_to(:user) 
      end 
    end
  end

  describe 'Dependents' do
    context 'comments' do
      it 'should remove associated comments when post is deleted' do
        should have_many(:comments).dependent(:destroy)
      end
    end
    context 'likes' do
      it 'should remove associated likes when post is deleted' do
        should have_many(:likes).dependent(:destroy)
      end
    end
  end

  

end
