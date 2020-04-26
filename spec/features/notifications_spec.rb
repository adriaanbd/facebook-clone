require 'rails_helper'

RSpec.feature "Notifications", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:user) }
  let(:friendship) { FactoryBot.create(:friendship, active_friend: user, passive_friend: friend) }
  let(:post) { FactoryBot.create(:post, user: user) }
  let!(:comment) { FactoryBot.create(:comment, user: friend, post: post) }
  let(:comment_notif) { FactoryBot.create(:notification, notifiable: comment, user: user) }

  scenario "user sees new notification" do 
    sign_in user
    visit("/notifications")

    expect(page).to have_content(comment.user.full_name)
  end

  scenario "user visit post from notifications" do 
    sign_in user 
    visit("/notifications")

    new_comment = "/#{post.user.username}/posts/#{comment.post_id}"
    
    find_link(href: new_comment).click()
    expect(page).to have_content(post.message)
  end
end
