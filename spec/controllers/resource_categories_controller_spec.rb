require 'rails_helper'

RSpec.describe ResourceCategoriesController, type: :controller do
  # index, show, new, create, edit, update and destroy

  describe 'as a logged out user' do
    let (:user) {create(:user)}
    let (:resource_category) {create(:resource_category)}

    # Index
    it {
      expect(get(:index)).to redirect_to new_user_session_path
    }

    # New
    it {
      expect(get(:index)).to redirect_to new_user_session_path
    }

    # Create
    it {
      post(:create, params: {resource_category: FactoryBot.attributes_for(:resource_category)})
      expect(response).to redirect_to new_user_session_path
    } 

    # Update
    it {
      patch(:update, params: {id: resource_category.id, resource_category: FactoryBot.attributes_for(:resource_category)})
      expect(response).to redirect_to new_user_session_path
    }

    # Destroy
    it {
      delete(:destroy, params: {id: resource_category.id})
      expect(response).to redirect_to new_user_session_path
    }
  end

  describe 'as a logged in user' do
    let (:user) {create(:user)}
    let (:resource_category) {create(:resource_category)}
    before (:each) {sign_in user}

    # Index
    it {
      expect(get(:index)).to redirect_to dashboard_path
    }

    # New
    it {
      expect(get(:index)).to redirect_to dashboard_path
    }

    # Create
    it {
      post(:create, params: {resource_category: FactoryBot.attributes_for(:resource_category)})
      expect(response).to redirect_to dashboard_path
    } 

    # Update
    it {
      patch(:update, params: {id: resource_category.id, resource_category: FactoryBot.attributes_for(:resource_category)})
      expect(response).to redirect_to dashboard_path
    }

    # Destroy
    it {
      delete(:destroy, params: {id: resource_category.id})
      expect(response).to redirect_to dashboard_path
    }
  end

  describe 'as admin' do
    let (:user) {create(:user, :admin)}
    let (:resource_category) {create(:resource_category)}
    before (:each) {sign_in user}

    # Index
    it {
      expect(get(:index)).to be_successful
    }

    # New
    it {
      expect(get(:index)).to be_successful
    }

    # Create
    it {
      post(:create, params: {resource_category: FactoryBot.attributes_for(:resource_category)})
      expect(response).to redirect_to resource_categories_path
    } 

    # Update
    it {
      patch(:update, params: {id: resource_category.id, resource_category: FactoryBot.attributes_for(:resource_category)})
      expect(response).to redirect_to resource_category
    }

    # Destroy
    it {
      delete(:destroy, params: {id: resource_category.id})
      expect(response).to redirect_to resource_categories_path
    }
  end
end
