require 'rails_helper'

RSpec.feature "Posts", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let!(:post) { FactoryBot.create(:post, user: user) }

  scenario "user deletes a post" do 
    sign_in user 
    visit root_path

    expect{
      click_link("Delete post")
    }.to change(Post, :count).by(-1)
  end
end
