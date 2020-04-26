# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#

require 'rails_helper'

RSpec.describe Like, type: :model do
  
  let(:like) { FactoryBot.create(:like) }

  
  describe 'test for presence of model attributes' do
    context 'general expected attributes' do
      it 'should include user_id attribute' do
        expect(like.attributes).to include('user_id')
      end

      it 'should include message attribute' do
        expect(like.attributes).to include('post_id')
      end
    end

    context 'Rails specific attributes' do
      it 'should include the :created_at attribute' do 
        expect(like.attributes).to include('created_at')
      end

      it 'should include the :updated_at attribute' do 
        expect(like.attributes).to include('updated_at')
      end

      it 'should include the :id attribute' do 
        expect(like.attributes).to include('id')
      end
    end
  end

  describe 'Basic validations' do
    context 'user_id' do 
      it 'is valid with a user_id' do 
        like.valid?
        expect(like.errors[:user_id]).to_not include("can't be blank")
      end

      it 'is invalid without a user_id' do 
        like.user_id = nil
        like.valid?
        expect(like.errors[:user_id]).to include("can't be blank")
      end
    end

    context 'post_id' do
      it 'is valid with a post_id' do 
        like.valid?
        expect(like.errors[:post_id]).to_not include("can't be blank")
      end

      it 'is invalid without a post_id' do 
        like.post_id = nil
        like.valid?
        expect(like.errors[:post_id]).to include("can't be blank")
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

  describe 'Dependents' do
    context 'notifications' do
      it 'should remove associated notifications when like is deleted' do
        should have_many(:notifications).dependent(:destroy)
      end
    end
  end

end
