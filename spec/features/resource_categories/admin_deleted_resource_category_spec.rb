require 'rails_helper'

RSpec.describe 'Deleting a Resource Category', type: :feature do

  let (:admin) {create(:user, :admin)}
  let (:resource_category) {create(:resource_category)}

  before {log_in_as(admin)}

  it 'can be done by admin' do
    name = resource_category.to_s
    visit resource_category_path(resource_category.id)
    click_on 'Delete'

    expect(current_path).to eq(resource_categories_path)
    expect(page).to have_content("Category #{name} was deleted.")
    expect(ResourceCategory.exists?(name: name)).to be false
  end
end
