require 'rails_helper'

RSpec.describe 'Creating a Region', type: :feature do
  let (:admin) {create(:user, :admin)}

  before {log_in_as(admin)}

  it 'succeeds when a name is provided' do
    visit new_region_path
    fill_in 'Name', with: 'FAKE'
    click_on 'Add Region'

    expect(current_path).to eq(regions_path)
    expect(page.body).to have_text('FAKE')
  end

  it 'fails when a name is not provided or is too short' do
    visit new_region_path
    click_on 'Add Region'
    fill_in 'Name', with: ''

    expect(current_path).to eq(regions_path)
    expect(page).to have_content("Name can't be blank")
  end

  it 'fails when name is already taken' do
    visit new_region_path
    fill_in 'Name', with: 'Bend'
    click_on 'Add Region'

    click_on 'Add Region'
    fill_in 'Name', with: 'Bend'
    click_on 'Add Region'

    expect(current_path).to eq(regions_path)
    expect(page).to have_content("Name has already been taken")
  end
end
