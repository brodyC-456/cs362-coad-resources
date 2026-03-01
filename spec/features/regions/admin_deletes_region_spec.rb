require 'rails_helper'

RSpec.describe 'Deleting a Region', type: :feature do
  let (:admin) {create(:user, :admin)}
  let (:region) {create(:region)}
  
  before {log_in_as(admin)}

  it 'can be done by admin' do
    visit region_path(region.id)
    region_name = region.to_s
    click_on 'Delete'
    
    
    expect(current_path).to eq(regions_path)
    expect(page).to have_content("Region #{region_name} was deleted.")
    expect(Region.exists?(name: region_name)).to be false
  end
end
