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

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and 
  before_save { [first_name.capitalize!, last_name.capitalize!, create_username] }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  validates :first_name, presence: true, length: { maximum: 35 }
  validates :last_name, presence: true, length: { maximum: 35 }
  validates :email, length: { maximum: 255 }
  validates :gender, presence: true, inclusion: { in: %w(Male Female),
    message: "%{value} is not a valid gender" }
  VALID_BIRTHDATE_REGEX = /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/
  validates :birth_date, presence: true, 
                         format: { 
                         with: VALID_BIRTHDATE_REGEX,  
                         message: "%{value} is not a valid date format of YYYY-MM-DD" 
                        }
  validates :password, presence: true, 
                       length: { in: 6..20 }


  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :active_friend_requests, class_name: 'FriendRequest',
                                    foreign_key: 'requester_id',
                                    dependent: :destroy
  has_many :passive_friend_requests, class_name: 'FriendRequest',
                                     foreign_key: 'requestee_id',
                                     dependent: :destroy

  has_many :sent_requests, through: :active_friend_requests,
                                    source: :requestee
  has_many :received_requests, through: :passive_friend_requests,
                                        source: :requester

  has_many :active_friendships, foreign_key: :active_friend_id,
                                class_name: 'Friendship',
                                dependent: :destroy
  has_many :passive_friendships, foreign_key: :passive_friend_id, 
                                 class_name: 'Friendship',
                                 dependent: :destroy


  has_many :active_friends, through: :active_friendships, source: :passive_friend
  has_many :passive_friends, through: :passive_friendships, source: :active_friend

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.name.split.first
      user.last_name = auth.info.name.split.last
    end
  end

  def full_name
  	"#{first_name} #{last_name}"
  end

  def friends
    active_friends + passive_friends
  end

  def friends_posts
    if active_friends_posts && passive_friends_posts
      return active_friends_posts + passive_friends_posts
    elsif active_friends_posts
      return active_friends_posts
    elsif passive_friends_posts
      return passive_friends_posts
    end
  end

  def home_posts
    if friends_posts && posts
      return friends_posts + posts
    elsif friends_posts
      return friends_posts
    elsif posts
      return posts
    end
  end
  def create_username
    u = first_name + last_name[0]
    self.username = find_unique_username(u.downcase)
  end      

  private  

  def find_unique_username(username)
    taken_usernames = User.where("username LIKE ?", "#{username}%").pluck(:username)

    return username if !taken_usernames.include?(username)

    count = 2
    while true
      new_username = "#{username}#{count}"
      return new_username if !taken_usernames.include?(new_username)
      count += 1
    end
  end  

  def active_friends_posts
    posts = active_friends[0].posts if active_friends[0]
    for i in 1..active_friends.length do
      posts += active_friends[i].posts if active_friends[i]
    end
    posts
  end

  def passive_friends_posts
    posts = passive_friends[0].posts if passive_friends[0]
    for i in 1..passive_friends.length do
      posts += passive_friends[i].posts if passive_friends[i]
    end
    posts
  end    
end
