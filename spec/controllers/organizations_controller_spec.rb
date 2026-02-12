# Note: Show and edit are empty in the controller, so I don't think we need to test them?
# Also not sure if i need to test reject or approve, I don't think i do but idk

require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do

    describe 'as logged out user' do
      let (:user) { create(:user) }
      let (:organization) {create(:organization)}

      # Index
      it {
        expect(get(:index)).to redirect_to new_user_session_path
      }

      # New
      it {
        expect(get(:new)).to redirect_to new_user_session_path
      }

      # Create
      it {
        post(:create, params: {organization: FactoryBot.attributes_for(:organization)})
        expect(response).to redirect_to new_user_session_path
      }

      # Update
      it {
        patch(:update, params: {id: organization.id, organization: FactoryBot.attributes_for(:organization)})
        expect(response).to redirect_to new_user_session_path
      }
    end

    describe 'as logged in user' do
      let (:user) { create(:user) }
      let (:organization) {create(:organization)}
      before (:each) { sign_in user }

      # Index
      it {
        expect(get(:index)).to be_successful
      }

      # New
      it {
        expect(get(:new)).to be_successful
      }

      # Create -- requires a stub to be written cleanly so ill skip for now
    #   it {
    #     post(:create, params: {organization: FactoryBot.attributes_for(:organization)})
    #     expect(response).to be_successful
    #   }

      # Update
      it {
        patch(:update, params: {id: organization.id, organization: FactoryBot.attributes_for(:organization)})
        expect(response).to redirect_to dashboard_path
      }
      
    end

    describe 'as admin' do
      let (:user) { create(:user, :admin) }
      let (:organization) {create(:organization)}
      before (:each) { sign_in user }

      # Index
      it {
        expect(get(:index)).to be_successful
      }

      # New
      it {
        expect(get(:new)).to redirect_to dashboard_path
      }

      # Create
      it {
        post(:create, params: {organization: FactoryBot.attributes_for(:organization)})
        expect(response).to redirect_to dashboard_path
      }

      # Update
      it {
        patch(:update, params: {id: organization.id, organization: FactoryBot.attributes_for(:organization)})
        expect(response).to redirect_to dashboard_path
      }
    end

end
