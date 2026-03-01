require 'rails_helper'

RSpec.describe 'User registration', type: :feature do
  
  it 'is successful when all info is provided and valid' do
    visit signup_path
    fill_in 'Email address', with: 'fake01@gmail.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    find("#commit").click

    expect(current_path).to eq(root_path)
    expect(page).to have_content("A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.")
  end

  it 'fails when password confirmation doesnt match password' do
    visit signup_path
    fill_in 'Email address', with: 'fake01@gmail.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password1234'
    find("#commit").click

    expect(current_path).to eq(user_registration_path)
    expect(page).to have_content("Password confirmation doesn't match Password")
  end
end
