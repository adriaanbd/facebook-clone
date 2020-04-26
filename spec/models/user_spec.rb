# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birth_date             :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  gender                 :string
#  last_name              :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

require 'rails_helper'
require 'faker'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:user2) { FactoryBot.build(:user) }
  
  describe 'test for presence of model attributes for' do
    describe 'general expected attributes' do 
      it 'should include the :first_name attribute' do 
        expect(user.attributes).to include('first_name')
      end

      it 'should include the :last_name attribute' do 
        expect(user.attributes).to include('last_name')
      end

      it 'should include the :email attribute' do 
        expect(user.attributes).to include('email')
      end

      it 'should include the :gender attribute' do 
        expect(user.attributes).to include('gender')
      end

      it 'should include the :birthdate attribute' do 
        expect(user.attributes).to include('birth_date')
      end
    end 

    describe 'Devise specific attributes' do 
      it 'should include the :encrypted_password attribute' do 
        expect(user.attributes).to include('encrypted_password')
      end

      it 'should include the :reset_password_sent_at attribute' do 
        expect(user.attributes).to include('reset_password_sent_at')
      end

      it 'should include the :reset_password_token attribute' do 
        expect(user.attributes).to include('reset_password_token')
      end

      it 'should include the :remember_created_at attribute' do 
        expect(user.attributes).to include('remember_created_at')
      end
    end

    describe 'Rails specific attributes' do
      it 'should include the :created_at attribute' do 
        expect(user.attributes).to include('created_at')
      end

      it 'should include the :updated_at attribute' do 
        expect(user.attributes).to include('updated_at')
      end

      it 'should include the :id attribute' do 
        expect(user.attributes).to include('id')
      end
    end
  end

  describe 'Basic validations' do
    context 'first_name' do
      it 'is valid with a first name' do 
        user.valid?
        expect(user.errors[:first_name]).to_not include("can't be blank")
      end

      it 'is valid if length is less than 36 characters' do
        user.valid?
        expect(user.errors[:first_name]).to_not include('is too long (maximum is 35 characters)')
      end

      it 'is invalid if length is more than 35 characters' do
        user.first_name = 'a' * 36
        user.valid?
        expect(user.errors[:first_name]).to include('is too long (maximum is 35 characters)')
      end

      it 'is invalid without a first name' do 
        user.first_name = nil
        user.valid?
        expect(user.errors[:first_name]).to include("can't be blank")
      end


    end
    context 'last_name' do
      it 'is valid with a last name' do 
        user.valid?
        expect(user.errors[:last_name]).to_not include("can't be blank")
      end

      it 'is valid if length is less than 36 characters' do
        user.valid?
        expect(user.errors[:last_name]).to_not include('is too long (maximum is 35 characters)')
      end

      it 'is invalid if length is more than 35 characters' do
        user.last_name = 'a' * 36
        user.valid?
        expect(user.errors[:last_name]).to include('is too long (maximum is 35 characters)')
      end

      it 'is invalid without a last name' do 
        user.last_name = nil
        user.valid?
        expect(user.errors[:last_name]).to include("can't be blank")
      end
    end

    context 'email' do
      it 'is valid with an email' do 
        user.valid?
        expect(user.errors[:email]).to_not include("can't be blank")
      end

      it 'is valid if length is less than 3 characters' do
        user.valid?
        expect(user.errors[:email]).to_not include('is too short (minimum is 3 characters)')
      end

      it 'is invalid if length is more than 255 characters' do
        user.email = 'a' * 255 + '@example.com'
        user.valid?
        expect(user.errors[:email]).to include('is too long (maximum is 255 characters)')
      end

      it 'is invalid without an email' do 
        user.email = nil
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end 
    end
    context 'gender' do
      it 'is valid with a gender' do 
        user.valid?
        expect(user.errors[:gender]).to_not include("can't be blank")
      end 

      it 'is valid if gender is male or female' do
        user.valid?
        expect(user.errors[:gender]).to_not include("#{user.gender} is not a valid gender")
      end

      it 'is invalid if gender is not male or female' do
        user.gender = 'Maggot'
        user.valid?
        expect(user.errors[:gender]).to include("#{user.gender} is not a valid gender")
      end

      it 'is invalid without a gender' do 
        user.gender = nil
        user.valid?
        expect(user.errors[:gender]).to include("can't be blank")
      end 
    end
    
    context 'birth_date' do
      it 'is valid with a birth date' do 
        user.valid?
        expect(user.errors[:birth_date]).to_not include("can't be blank")
      end 

      it 'is invalid without a birth date' do 
        user.birth_date = nil
        user.valid?
        expect(user.errors[:birth_date]).to include("can't be blank")
      end 

      it 'is invalid with an invalid birth date format' do 
        user.birth_date = '01-01-01'
        user.valid?
        expect(user.errors[:birth_date]).to include("#{user.birth_date} is not a valid date format of YYYY-MM-DD")
      end
    end
    
    context 'password' do
      it 'is valid with a password' do 
        user.valid?
        expect(user.errors[:password]).to_not include("can't be blank")
      end

      it 'is invalid without a password' do 
        user.password = nil
        user.valid?
        expect(user.errors[:password]).to include("can't be blank")
      end

      it 'is invalid if length is less than 6 characters' do
        user.valid?
        expect(user.errors[:password]).to_not include('is too short (minimum is 6 characters)')
      end

      it 'is invalid if length is more than 20 characters' do
        user.password = 'a' * 21
        user.valid?
        expect(user.errors[:password]).to include('is too long (maximum is 20 characters)')
      end
    end
  end

  describe "Associations" do

    context 'posts' do 
      it 'has correct has_many association' do 
        should have_many(:posts) 
      end
    end

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

    context 'friend_requests' do 
      it 'have many active_friend_requests' do 
        should have_many(:active_friend_requests) 
      end
      it 'have many passive_friend_requests' do 
        should have_many(:passive_friend_requests) 
      end

      it 'has many sent_requests through active_friend_requests' do
        should have_many(:sent_requests).through(:active_friend_requests).source(:requestee)
      end
      it 'has many sent_requests through passive_friend_requests' do
        should have_many(:received_requests).through(:passive_friend_requests).source(:requester)
      end
    end

    context 'friendships' do 
      it 'have many active_friendships' do 
        should have_many(:active_friendships) 
      end
      it 'have many passive_friendships' do 
        should have_many(:passive_friendships) 
      end

      it 'has many active_friends through active_friend_requests' do
        should have_many(:active_friends).through(:active_friendships)
      end
      it 'has many passive_friends through passive_friend_requests' do
        should have_many(:passive_friends).through(:passive_friendships)
      end
    end
  end

  describe 'Dependents' do
    context 'friend_requests' do
      it 'should remove associated active_friend_requests when user is deleted' do
        should have_many(:active_friend_requests).dependent(:destroy)
      end
      it 'should remove associated passive_friend_requests when user is deleted' do
        should have_many(:passive_friend_requests).dependent(:destroy)
      end
    end
    context 'friendships' do
      it 'should remove associated active_friendships when user is deleted' do
        should have_many(:active_friendships).dependent(:destroy)
      end
      it 'should remove associated passive_friendships when user is deleted' do
        should have_many(:passive_friendships).dependent(:destroy)
      end
    end
    context 'posts' do
      it 'should remove associated posts when user is deleted' do
        should have_many(:posts).dependent(:destroy)
      end
    end
    context 'comments' do
      it 'should remove associated comments when user is deleted' do
        should have_many(:comments).dependent(:destroy)
      end
    end
    context 'likes' do
      it 'should remove associated likes when user is deleted' do
        should have_many(:likes).dependent(:destroy)
      end
    end
  end

  describe 'public model functions' do
    context 'full_name method' do
      it 'returns full name via concatenation of first_name and last_name variables with space between' do
        expect(user2.full_name).to eq("#{user2.first_name} #{user2.last_name}")
      end
    end
    context 'create_username method when first_name and last_name[0] combination unique' do
      it 'returns username via concatenation of first_name and first letter of last_name variables' do
        exp_username = user2.first_name.downcase + user2.last_name[0].downcase
        expect(user2.create_username).to eq(exp_username)
      end
    end
    context 'create_username method when first_name and last_name[0] combination already exists' do
      it 'returns username via concatenation of first_name and first letter of last_name variables' do
        user3 = user2
        user2.save!
        user3.email = 'anuniqueemail@example.com'

        exp_username = "#{user3.first_name.downcase}#{user3.last_name[0].downcase}2"
        expect(user3.create_username).to eq(exp_username)
      end
    end
  end
end
