# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  notifiable_type :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :bigint
#  user_id         :integer
#
# Indexes
#
#  index_notifications_on_notifiable_type_and_notifiable_id  (notifiable_type,notifiable_id)
#  index_notifications_on_user_id                            (user_id)
#

require 'rails_helper'

RSpec.describe Notification, type: :model do
  let!(:notification) { FactoryBot.build(:notification) }
  let!(:like_notification) { FactoryBot.create(:notification, :for_like) }
  let!(:comment_notification) { FactoryBot.create(:notification, :for_comment) }
  let(:status) { ['Read', 'Unread'][rand(0..1)] }

  let(:ilegal_like) { Like.count.nil? ? 1 : Like.count + 1 }
  let(:ilegal_comment) {  Comment.count.nil? ? 1 : Comment.count + 1  }

  let(:comment_model) { 'Comment' }
  let(:like_model) { 'Like' }
  

  describe 'test for presence of model attributes for' do
    describe 'general expected attributes' do 

      it 'should include the :status attribute' do 
        expect(notification.attributes).to include('status')
      end
    end 

    describe 'Rails specific' do
      context 'general attributes' do

        it 'should include the :created_at attribute' do 
          expect(notification.attributes).to include('created_at')
        end

        it 'should include the :updated_at attribute' do 
          expect(notification.attributes).to include('updated_at')
        end

        it 'should include the :id attribute' do 
          expect(notification.attributes).to include('id')
        end
      end

      context 'polymorphic attributes' do 
        it 'should include the :notifiable_type attribute' do 
          expect(notification.attributes).to include('notifiable_type')
        end

        it 'should include the :notification_type_id attribute' do 
          expect(notification.attributes).to include('notifiable_id')
        end
      end 
    end
  end

  describe 'Basic validations' do

    context 'notifiable_type' do 
      it 'is valid with a Like notifiable_type' do 
        like_notification.valid?
        expect(like_notification.errors[:notifiable_type]).to_not include("can't be blank")
      end

      it 'is valid with a Comment notifiable_type' do 
        comment_notification.valid?
        expect(like_notification.errors[:notifiable_type]).to_not include("can't be blank")
      end

      it 'is invalid without a notifiable_type' do 
        notification.valid?
        expect(notification.errors[:notifiable_type]).to include("can't be blank")
      end
    end

    context 'notifiable_id' do 
      it 'is valid with a Like notifiable_id' do 
        like_notification.valid?
        expect(like_notification.errors[:notifiable_id]).to_not include("can't be blank")
      end

      it 'is valid with a Comment notifiable_id' do 
        comment_notification.valid?
        expect(like_notification.errors[:notifiable_id]).to_not include("can't be blank")
      end

      it 'is invalid without a notifiable_id' do 
        notification.valid?
        expect(notification.errors[:notifiable_id]).to include("can't be blank")
      end
    end

    context 'status' do 
      it 'is only valid with a Read or Unread status' do 
        notification.status = status
        notification.valid?
        expect(notification.errors[:status]).to_not include("#{status} is not a valid status")
      end

      it 'is invalid without a Read or Unread status' do 
        notification.status = "Maggot"
        notification.valid?
        expect(notification.errors[:status]).to include("#{notification.status} is not a valid status")
      end
    end
  end

  describe "Associations" do

    context 'polymorphism' do 
      it 'has correct belongs_to association' do 
        should belong_to(:notifiable) 
      end 
    end
  end
  
  describe 'Constraints' do 
    context 'when notification is created with Like that does not exist' do 
      it 'should raise nofiable_id must exist error' do 
        notification.notifiable_type = like_model
        notification.notifiable_id = ilegal_like

        expect { notification.save! }.to  raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Notifiable must exist')
      end 
    end 

    context 'when notification is created with Comment that does not exist' do 
      it 'should raise nofiable_id must exist error' do 
        notification.notifiable_type = comment_model
        notification.notifiable_id = ilegal_comment

        expect { notification.save! }.to  raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Notifiable must exist')
      end 
    end
  end
end
