require 'rails_helper'

RSpec.describe 'Creating a Region', type: :feature do
    let (:admin) {create(:user, :admin)}
    it 'succeeds when a name is provided' do
        log_in_as(admin)
        visit new_region_path
        fill_in 'Name', with: 'FAKE'
        click_on 'Add Region'
        expect(current_path).to eq(regions_path)
        expect(page.body).to have_text('FAKE')
    end
end
