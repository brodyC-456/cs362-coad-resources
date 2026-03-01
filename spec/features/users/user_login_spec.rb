require 'rails_helper'

RSpec.describe 'Logging in', type: :feature do
  let (:user) {create(:user)}
  let (:admin) {create(:user, :admin)}

  it 'as a basic user is successful' do
    log_in_as(user)
    expect(page).to have_content("Signed in successfully")
    expect(current_path).to eq(dashboard_path)
  end

  it 'as an admin is successful' do 
    log_in_as(admin)
    expect(page).to have_content("Signed in successfully")
    expect(current_path).to eq(dashboard_path)
  end
end
