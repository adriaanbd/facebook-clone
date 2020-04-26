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

class Comment < ApplicationRecord
  validates :message, presence: true, length: { maximum: 7000 }
  validates :user_id, presence: true
  validates :post_id, presence: true

  belongs_to :post 
  belongs_to :user

  has_many :notifications, :as => :notifiable, dependent: :destroy

  after_create :find_post, :create_notification

  def create_notification
    notification = Notification.new(notifiable_type: 'Comment', notifiable_id: id, user_id: @post.user_id)
    notification.save
  end

  private 

  def find_post
    @post = Post.find(post_id)
  end
end
