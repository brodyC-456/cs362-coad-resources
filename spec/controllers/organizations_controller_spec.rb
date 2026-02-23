# Note: Show and edit are empty in the controller, so I don't think we need to test them?

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
      let(:user) { create(:user, role: :organization) }

      before do
        sign_in user
        # Stubbing helpers
        allow(controller).to receive(:verify_unapproved).and_return(true)
        allow(controller).to receive(:verify_approved).and_return(true)
        # Stubbing Mail
        mail_double = double(deliver_now: true)
        allow(UserMailer).to receive(:with).and_return(double(new_organization_application: mail_double))
      end

      it {expect(get(:index)).to be_successful}
      it {expect(get(:new)).to be_successful}

      it 'creates organization' do
        expect {post(:create, params: { organization: attributes_for(:organization) })}.to change(Organization, :count).by(1)
        expect(user.reload.organization).to be_present
        expect(response).to redirect_to organization_application_submitted_path
      end

      it 'updates organization' do
        org = create(:organization, status: :approved)
        patch(:update, params: {id: org.id,organization: { name: "Updated" }})
        expect(org.reload.name).to eq("Updated")
        expect(response).to redirect_to organization_path(id: org.id)
      end
    end

    describe 'as admin' do
      let (:user) { create(:user, :admin) }
      let(:fake_org) {instance_double(Organization, id: 1, name: "Test Org",approve: true,reject: true,save: true)}
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
        patch(:update, params: {id: fake_org.id, organization: FactoryBot.attributes_for(:organization)})
        expect(response).to redirect_to dashboard_path
      }
    end

  describe "approve and reject logic" do
    let (:admin) {create(:user, :admin)}
    let (:organization) {create(:organization)}
    before (:each) {sign_in admin}

    # Approve
    it do
      patch(:approve, params: {id: organization.id})
      expect(response).to redirect_to organizations_path
    end

    # Reject
    it do
      patch(:reject, params: {id: organization.id, organization: {rejection_reason:"invalid"}})
      expect(response).to redirect_to organizations_path
    end
  end

end