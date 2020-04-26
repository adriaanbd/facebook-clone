# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryBot.create(:comment) }


  describe 'test for presence of model attributes' do
    context 'general expected attributes' do
      it 'should include post_id attribute' do
        expect(comment.attributes).to include('post_id')
      end

      it 'should include user_id attribute' do
        expect(comment.attributes).to include('user_id')
      end

      it 'should include message attribute' do
        expect(comment.attributes).to include('message')
      end
    end

    context 'Rails specific attributes' do
      it 'should include the :created_at attribute' do 
        expect(comment.attributes).to include('created_at')
      end

      it 'should include the :updated_at attribute' do 
        expect(comment.attributes).to include('updated_at')
      end

      it 'should include the :id attribute' do 
        expect(comment.attributes).to include('id')
      end
    end
  end

  describe 'Basic validations' do
    context 'message' do
      it 'is valid with a message' do 
        comment.valid?
        expect(comment.errors[:message]).to_not include("can't be blank")
      end

      it 'is valid if length is less than  7,000 characters' do
        comment.valid?
        expect(comment.errors[:message]).to_not include('is too long (maximum is 7,000 characters)')
      end

      it 'is invalid if length is more than 7,000 characters' do
        comment.message = 'a' * 7001
        comment.valid?
        expect(comment.errors[:message]).to include('is too long (maximum is 7000 characters)')
      end

      it 'is invalid without a message' do 
        comment.message = nil
        comment.valid?
        expect(comment.errors[:message]).to include("can't be blank")
      end
    end

    context 'user_id' do
      it 'is valid with a user_id' do 
        comment.valid?
        expect(comment.errors[:user_id]).to_not include("can't be blank")
      end

      it 'is invalid without a user_id' do 
        comment.user_id = nil
        comment.valid?
        expect(comment.errors[:user_id]).to include("can't be blank")
      end
    end

    context 'post_id' do
      it 'is valid with a post_id' do 
        comment.valid?
        expect(comment.errors[:post_id]).to_not include("can't be blank")
      end

      it 'is invalid without a post_id' do 
        comment.post_id = nil
        comment.valid?
        expect(comment.errors[:post_id]).to include("can't be blank")
      end
    end
  end

  describe "Associations" do

    context 'post' do 
      it 'hast correct belongs_to association' do 
        should belong_to(:post) 
      end 
    end

    context 'user' do 
      it 'has correct belongs_to association' do 
        should belong_to(:user) 
      end
    end

    context 'notifications' do 
      it 'has a correct has_many association' do 
        should have_many(:notifications)
      end
    end 
  end
end
