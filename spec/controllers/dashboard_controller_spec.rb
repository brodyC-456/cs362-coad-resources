require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:admin) { create(:user, :admin)}
  let(:organization) { create(:organization)}
  let(:org_user) { create(:user, organization: organization)}
  let(:user) { create(:user)}

  describe "GET #index" do
    
    describe "as a guest" do
      it "redirects to sign-in page" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "as a logged in user" do
      describe "as an Admin" do
        before (:each) { sign_in admin }
        it "sets status_options Open, Captured, Closed" do
          get :index
          expect(assigns(:status_options)).to eq(['Open', 'Captured', 'Closed'])
        end
      end
      
      describe "an an Approved Organization User" do
        before (:each) { sign_in org_user }
        it "sets status_options Open, Captured, Closed" do
          get :index
          expect(assigns(:status_options)).to eq(['Open'])
        end
      end
      
      describe "as a regular User" do
        before (:each) { sign_in user }
        it "sets status to just Open" do
          get :index
          expect(assigns(:status_options)).to eq(['Open'])
        end
      end
      
    end
    
  end
  
end
