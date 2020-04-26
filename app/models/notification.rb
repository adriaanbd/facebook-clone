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

class Notification < ActiveRecord::Base 
  after_initialize :set_default_status
  validates :status, presence: true, inclusion: { in: %w(Unread Read),
    message: "%{value} is not a valid status" }
  validates :notifiable_type, presence: true 
  validates :notifiable_id, presence: true
  validates :user_id, presence: true

  belongs_to :notifiable, polymorphic: true
  belongs_to :user

  def set_default_status
    self.status = 'Unread'
  end
end
