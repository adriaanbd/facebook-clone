require 'rails_helper'

RSpec.feature "Profiles", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:new_user) { FactoryBot.build(:user) }

  scenario "user edits profile" do 
    sign_in user 
    visit profile_path(user.username)
    click_link("Edit profile")

    fill_in "Email", with: new_user.email 
    fill_in "user_password", with: user.password
    fill_in "user_current_password", with: user.password
    click_button "Update Account"

    expect(page).to have_content("Your account has been updated successfully.")
  end

  scenario "user deletes account" do 
    sign_in user 

    visit edit_profile_path(user.username)

    expect {
      click_button("Delete my account")
    }.to change(User, :count).by(-1)
  end
end
