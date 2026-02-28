require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #index" do
    it "returns a http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #ticket_submitted" do
    it "returns a http success" do
      get :ticket_submitted
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #organization_expectations" do
    it "returns a http success" do
      get :organization_expectations
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #organization_application_submitted" do
    context "when not logged in" do
      it "redirects to the login page" do
        get :organization_application_submitted
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in" do
      it "returns a http success" do
        user = create(:user)
        sign_in user
        get :organization_application_submitted
        expect(response).to have_http_status(:success)
      end
    end
  end
end
