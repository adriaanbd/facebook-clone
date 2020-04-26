require 'rails_helper'

RSpec.feature "Homes", type: :feature do
  let(:user) { FactoryBot.build(:user) }
  let(:stranger) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.build(:post, user: user) }
  let(:like) { FactoryBot.build(:like, post: post, user: user)}
  let(:comment) { FactoryBot.build(:comment, post: post, user: user)}
  let(:friend_request) { FactoryBot.build(:friend_request, requester: user, requestee: stranger)}
  let(:friendship) {FactoryBot.build(:friendship, active_friend: user, passive_friend: stranger)}
  let(:comment_from) { FactoryBot.build(:comment, post: post, user: stranger)}


  scenario "registered user signs in" do 
    user.save

    visit root_path

    within '#login-form' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password 
    end

    click_button 'Log in' 

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content "#{user.first_name}"
  end  

  scenario 'unregistered user fails to sign in' do 
    visit root_path

    within '#login-form' do
      fill_in 'Email', with: 'unregistered@test.com'
      fill_in 'Password', with: 'test123'
    end

    click_button 'Log in' 
    expect(page).to have_content 'Invalid'
  end

  scenario "guest registers new user" do 

    visit root_path

    within 'main' do
      fill_in 'First name', with: user.first_name
      fill_in 'Last name', with: user.last_name
      fill_in 'Email', with: user.email
      fill_in 'New Password', with: user.password 
      fill_in 'Birthday', with: user.birth_date 
      page.choose(name: 'user[gender]', option: user.gender)
    end

    expect {
      click_button 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(page).to have_content "#{user.first_name}"
    }.to change(User, :count).by(1)
  end

  scenario "user creates new post " do 
    user_sign_in

    mssg = post.message
    within "form" do 
      fill_in "post_message", with: post.message 
    end

    expect {
      click_button 'Post'
      expect(page).to have_content post.message
    }.to change(Post, :count).by(1)
  end

  scenario "user edits post" do 
    user_sign_in

    post.save
    created_post = "/#{user.username}/posts/#{post.id}/edit"
    visit root_path

    updated_mssg = "Dumbo Jumbo"
 
    find_link(href: created_post).click()

    fill_in "post_message", with: updated_mssg
    click_button 'Update Post'
    expect(page).to have_content updated_mssg      
  end


  scenario "user likes a post" do 
    user_sign_in
    post.save 
    
    visit root_path
    like_for_post = "/#{user.username}/posts/#{post.id}/likes?user_id=#{user.id}"

    expect {
      find_link(href: like_for_post).click()
    }.to change(Like, :count).by(1)
  end

  scenario "user unlikes a post" do 
    user_sign_in
    
    post.save
    like.save 

    visit root_path 

    unlike_for_post = "/#{user.username}/posts/#{like.post_id}/likes/#{like.id}?user_id=#{like.user_id}"

    expect {
      find_link(href: unlike_for_post).click()
    }.to change(Like, :count).by(-1)
  end

  scenario "user creates a comment" do 
    user_sign_in
    
    post.save
    created_post = "/#{user.username}/posts/#{post.id}/comments"

    visit root_path

    fill_in("comment_message", with: comment.message)

    expect {
      click_button "Comment"
      expect(page).to have_content(comment.message)
    }.to change(Comment, :count).by(1)
  end

  scenario "user deletes a comment" do 
    user_sign_in
    
    post.save
    comment.save

    visit root_path
    deleted_comment = "/#{user.username}/posts/#{post.id}/comments/#{comment.id}?user_id=#{comment.user_id}"

    expect {
      click_link(href: deleted_comment)
      expect(page).to_not have_content(comment.message)
    }.to change(Comment, :count).by(-1)
  end

  scenario "user looks at another user's profile" do 
    user_sign_in

    visit profile_path(stranger.username)

    expect(page).to have_content(stranger.full_name)
  end

  scenario "user accesses received requests" do 
    user_sign_in
    friend_request.requestee = user 
    friend_request.requester = stranger 
    friend_request.save 

    find_link(href: "/requests/received_requests").click()

    expect(page).to have_content("Friend Requests")
  end

  scenario "user accesses notifications" do 
    user_sign_in
    find_link(href: "/notifications").click()

    expect(page).to have_content("Your Notifications")
  end

  def user_sign_in
    user.save
    sign_in user
    visit root_path
  end
end
