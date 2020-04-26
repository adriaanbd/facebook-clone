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

class Like < ApplicationRecord
  validates :user_id, presence: true
  validates :post_id, presence: true

  belongs_to :post
  belongs_to :user

  has_many :notifications, :as => :notifiable, dependent: :destroy

  after_create :find_post, :create_notification

  def create_notification
    notification = Notification.new(notifiable_type: 'Like', notifiable_id: id, user_id: @post.user_id)
    notification.save
  end

  private 

  def find_post
    @post = Post.find(post_id)
  end
end
