require 'rails_helper'

RSpec.describe ResourceCategoriesController, type: :controller do
  # index, show, new, create, edit, update and destroy

  describe 'as a logged out user' do
    let (:resource_category) {create(:resource_category)}
    let(:mock_resource_category) { instance_double('ResourceCategory', id: "1") }

    before do
      allow(ResourceCategory).to receive(:find).with(mock_resource_category.id).and_return(mock_resource_category)
      allow(ResourceCategory).to receive(:new).and_return(mock_resource_category)
    end

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
      post(:create, params: {mock_resource_category: {name: 'Mock Resource Category'}})
      expect(response).to redirect_to new_user_session_path
    } 

    # Update
    it {
      patch(:update, params: {id: mock_resource_category.id, mock_resource_category: {name: 'Mock Resource Category'}})
      expect(response).to redirect_to new_user_session_path
    }

    # Destroy
    it {
      delete(:destroy, params: {id: mock_resource_category.id})
      expect(response).to redirect_to new_user_session_path
    }
  end

  describe 'as a logged in user' do
    let (:user) {create(:user)}
    let(:mock_resource_category) { instance_double('ResourceCategory', id: "1") }

    before (:each) {sign_in user}
    before do
      # Stub Ticket.find for destroy action
      allow(ResourceCategory).to receive(:find).with(mock_resource_category.id).and_return(mock_resource_category)
      allow(ResourceCategory).to receive(:new).and_return(mock_resource_category)
    end

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
      patch(:update, params: {id: mock_resource_category.id, resource_category: FactoryBot.attributes_for(:resource_category)})
      expect(response).to redirect_to dashboard_path
    }

    # Destroy
    it {
      delete(:destroy, params: {id: mock_resource_category.id})
      expect(response).to redirect_to dashboard_path
    }
  end

  describe 'as admin' do
    let (:user) {create(:user, :admin)}
    let(:mock_resource_category) { instance_double('ResourceCategory', id: "1", 
      name: 'Mock Category', save: true, update: true, destroy: true) }
    
    before (:each) {sign_in user}
    before do
      allow(ResourceCategory).to receive(:find).with(mock_resource_category.id).and_return(mock_resource_category)
      allow(ResourceCategory).to receive(:new).and_return(mock_resource_category)
      allow(mock_resource_category).to receive(:to_model).and_return(mock_resource_category)
      tickets_double = double(update: true)
      allow(mock_resource_category).to receive(:tickets).and_return(tickets_double)
      
      allow(mock_resource_category).to receive(:model_name).and_return(ResourceCategory.model_name)
      allow(mock_resource_category).to receive(:to_param).and_return("1")
      allow(mock_resource_category).to receive(:persisted?).and_return(true)
    end

    # Index
    it {
      expect(get(:index)).to be_successful
    }

    # New
    it {
      expect(get(:new)).to be_successful
    }

    # Create
    it {
      post(:create, params: {resource_category: FactoryBot.attributes_for(:resource_category)})
      expect(response).to redirect_to resource_categories_path
    } 

    # Update
    it {
      patch(:update, params: {id: mock_resource_category.id, resource_category: FactoryBot.attributes_for(:resource_category)})
      expect(response).to redirect_to mock_resource_category
    }

    # Destroy
    it {
      delete(:destroy, params: {id: mock_resource_category.id})
      expect(response).to redirect_to resource_categories_path
    }
  end
end
