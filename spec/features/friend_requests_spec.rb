require 'rails_helper'

RSpec.feature "FriendRequests", type: :feature do
  let(:user) { FactoryBot.build(:user) }
  let(:stranger) { FactoryBot.create(:user) }
  let(:friend_request) { FactoryBot.build(:friend_request, requester: nil, requestee: nil)}

  scenario "user requests friendship to stranger" do 
    user_sign_in

    visit profile_path(stranger.username)
    add_friend = "/#{stranger.username}/friend_requests"

    expect {
      find_link(href: add_friend).click()
    }.to change(user.sent_requests, :count).by(1)
  end

  scenario "user sees new received request" do 
    user_sign_in
    friend_request.requestee = user 
    friend_request.requester = stranger 
    friend_request.save 

    visit("/requests/received_requests")

    expect(page).to have_content("#{friend_request.requester.full_name}")
  end

  scenario "user accepts new received request" do 
    user_sign_in
    friend_request.requestee = user 
    friend_request.requester = stranger 
    friend_request.save 

    visit("/requests/received_requests")

    expect {
      click_link("Confirm")
    }.to change(Friendship, :count).by(1)
  end

  scenario "user accepts new received request" do 
    user_sign_in
    friend_request.requestee = user 
    friend_request.requester = stranger 
    friend_request.save 

    visit("/requests/received_requests")

    expect {
      click_link("Delete Request")
    }.to change(FriendRequest, :count).by(-1)
  end

  scenario "user sees new sent_request" do 
    user_sign_in
    friend_request.requester = user 
    friend_request.requestee = stranger
    friend_request.save

    visit("/requests/sent_requests")

    expect(page).to have_content("#{stranger.full_name}")
  end

  def user_sign_in
    user.save 
    sign_in user 
    visit root_path
  end
end
