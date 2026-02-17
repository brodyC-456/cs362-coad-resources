require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:region) { create(:region) }
  let(:resource_category) { create(:resource_category) }

  let(:admin) { create(:user, :admin) }

  let(:org_a) { create(:organization, status: :approved, name: "Org A", email: "org_a@example.com") }
  let(:user_org_a) { create(:user, role: :organization, organization: org_a, email: "user_a@example.com") }

  let(:org_b) { create(:organization, status: :approved, name: "Org B", email: "org_b@example.com") }

  let(:unapproved_org) { create(:organization, status: :submitted, name: "New Org", email: "new@example.com") }
  let(:user_unapproved) { create(:user, role: :organization, organization: unapproved_org, email: "new_user@example.com") }
  
  let!(:ticket_open) { 
    create(:ticket, region: region, resource_category: resource_category) 
  }
  
  let!(:ticket_closed) { 
    create(:ticket, :closed, region: region, resource_category: resource_category) 
  }
  
  let!(:ticket_captured_a) { 
    create(:ticket, organization: org_a, region: region, resource_category: resource_category) 
  }
  
  let!(:ticket_closed_a) { 
    create(:ticket, :closed, organization: org_a, region: region, resource_category: resource_category) 
  }

  let!(:ticket_captured_b) { 
    create(:ticket, organization: org_b, region: region, resource_category: resource_category) 
  }


  describe "GET #index" do
    
    # --- Admin Tests ---
    context "as an Admin" do
      before { sign_in admin }

      it "can see all Open tickets" do
        get :index, params: { status: 'Open' }
        expect(assigns(:tickets)).to include(ticket_open)
        expect(assigns(:tickets)).not_to include(ticket_captured_a)
      end

      it "can see all Captured tickets from ANY organization" do
        get :index, params: { status: 'Captured' }
        expect(assigns(:tickets)).to include(ticket_captured_a)
        expect(assigns(:tickets)).to include(ticket_captured_b)
      end

      it "can see all Closed tickets" do
        get :index, params: { status: 'Closed' }
        expect(assigns(:tickets)).to include(ticket_closed)
        expect(assigns(:tickets)).to include(ticket_closed_a)
      end
    end

    # --- Approved Org User Tests ---
    context "as an Approved Organization User (Org A)" do
      before { sign_in user_org_a }

      it "can see Open tickets" do
        get :index, params: { status: 'Open' }
        expect(assigns(:tickets)).to include(ticket_open)
      end

      it "can see their own Captured tickets" do
        get :index, params: { status: 'My Captured' }
        expect(assigns(:tickets)).to include(ticket_captured_a)
      end

      it "does NOT see tickets captured by other organizations" do
        get :index, params: { status: 'My Captured' }
        expect(assigns(:tickets)).not_to include(ticket_captured_b)
      end

      it "can see their own Closed tickets" do
        get :index, params: { status: 'My Closed' }
        expect(assigns(:tickets)).to include(ticket_closed_a)
      end
    end

    # --- Regular/Unapproved User Tests ---
    context "as a Regular User (Unapproved Org)" do
      before { sign_in user_unapproved }

      it "can see Open tickets" do
        get :index, params: { status: 'Open' }
        expect(assigns(:tickets)).to include(ticket_open)
        expect(assigns(:tickets)).not_to include(ticket_captured_a)
      end
    end

  end
end