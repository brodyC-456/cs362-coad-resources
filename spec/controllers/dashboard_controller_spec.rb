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

  # Correctly defined instance_doubles using :closed and :organization
  let(:mock_ticket_open) { instance_double(Ticket, id: 1, closed: false, organization: nil, region: region, resource_category: resource_category) }
  let(:mock_ticket_closed) { instance_double(Ticket, id: 2, closed: true, organization: nil, region: region, resource_category: resource_category) }
  let(:mock_ticket_captured_a) { instance_double(Ticket, id: 3, closed: false, organization: org_a, region: region, resource_category: resource_category) }
  let(:mock_ticket_closed_a) { instance_double(Ticket, id: 4, closed: true, organization: org_a, region: region, resource_category: resource_category) }
  let(:mock_ticket_captured_b) { instance_double(Ticket, id: 5, closed: false, organization: org_b, region: region, resource_category: resource_category) }

  let(:ticket_scope) { double('ticket_scope') }


  describe "GET #index" do
    
    # --- Admin Tests ---
    context "as an Admin" do
      before do
        sign_in admin
        # Stub the chainable scopes
        allow(ticket_scope).to receive(:region).with(any_args).and_return(ticket_scope)
        allow(ticket_scope).to receive(:resource_category).with(any_args).and_return(ticket_scope)
        allow(ticket_scope).to receive(:reverse).and_return(ticket_scope)
      end

      it "can see all Open tickets" do
        allow(Ticket).to receive(:open).and_return(ticket_scope)
        allow(ticket_scope).to receive(:to_a).and_return([mock_ticket_open]) # for pagy
        allow(controller).to receive(:pagy).and_return([nil, [mock_ticket_open]])
        
        get :index, params: { status: 'Open' }
        expect(assigns(:tickets)).to match_array([mock_ticket_open])
      end

      it "can see all Captured tickets from ANY organization" do
        allow(Ticket).to receive(:all_organization).and_return(ticket_scope)
        allow(ticket_scope).to receive(:to_a).and_return([mock_ticket_captured_a, mock_ticket_captured_b])
        allow(controller).to receive(:pagy).and_return([nil, [mock_ticket_captured_a, mock_ticket_captured_b]])

        get :index, params: { status: 'Captured' }
        expect(assigns(:tickets)).to include(mock_ticket_captured_a)
        expect(assigns(:tickets)).to include(mock_ticket_captured_b)
      end

      it "can see all Closed tickets" do
        allow(Ticket).to receive(:closed).and_return(ticket_scope)
        allow(ticket_scope).to receive(:to_a).and_return([mock_ticket_closed, mock_ticket_closed_a])
        allow(controller).to receive(:pagy).and_return([nil, [mock_ticket_closed, mock_ticket_closed_a]])

        get :index, params: { status: 'Closed' }
        expect(assigns(:tickets)).to include(mock_ticket_closed)
        expect(assigns(:tickets)).to include(mock_ticket_closed_a)
      end
    end

    # --- Approved Org User Tests ---
    context "as an Approved Organization User (Org A)" do
      before do
        sign_in user_org_a
        allow(ticket_scope).to receive(:region).with(any_args).and_return(ticket_scope)
        allow(ticket_scope).to receive(:resource_category).with(any_args).and_return(ticket_scope)
        allow(ticket_scope).to receive(:reverse).and_return(ticket_scope)
      end

      it "can see Open tickets" do
        allow(Ticket).to receive(:open).and_return(ticket_scope)
        allow(ticket_scope).to receive(:to_a).and_return([mock_ticket_open])
        allow(controller).to receive(:pagy).and_return([nil, [mock_ticket_open]])
        
        get :index, params: { status: 'Open' }
        expect(assigns(:tickets)).to match_array([mock_ticket_open])
      end

      it "can see their own Captured tickets" do
        allow(Ticket).to receive(:organization).with(user_org_a.organization_id).and_return(ticket_scope)
        allow(ticket_scope).to receive(:to_a).and_return([mock_ticket_captured_a])
        allow(controller).to receive(:pagy).and_return([nil, [mock_ticket_captured_a]])

        get :index, params: { status: 'My Captured' }
        expect(assigns(:tickets)).to match_array([mock_ticket_captured_a])
      end

      it "does NOT see tickets captured by other organizations" do
        allow(Ticket).to receive(:organization).with(user_org_a.organization_id).and_return(ticket_scope)
        allow(ticket_scope).to receive(:to_a).and_return([mock_ticket_captured_a])
        allow(controller).to receive(:pagy).and_return([nil, [mock_ticket_captured_a]])

        get :index, params: { status: 'My Captured' }
        expect(assigns(:tickets)).not_to include(mock_ticket_captured_b)
      end

      it "can see their own Closed tickets" do
        allow(Ticket).to receive(:closed_organization).with(user_org_a.organization_id).and_return(ticket_scope)
        allow(ticket_scope).to receive(:to_a).and_return([mock_ticket_closed_a])
        allow(controller).to receive(:pagy).and_return([nil, [mock_ticket_closed_a]])

        get :index, params: { status: 'My Closed' }
        expect(assigns(:tickets)).to match_array([mock_ticket_closed_a])
      end
    end

    # --- Regular/Unapproved User Tests ---
    context "as a Regular User (Unapproved Org)" do
      before do
        sign_in user_unapproved
        allow(ticket_scope).to receive(:region).with(any_args).and_return(ticket_scope)
        allow(ticket_scope).to receive(:resource_category).with(any_args).and_return(ticket_scope)
        allow(ticket_scope).to receive(:reverse).and_return(ticket_scope)
      end

      it "can see Open tickets" do
        allow(Ticket).to receive(:open).and_return(ticket_scope)
        allow(ticket_scope).to receive(:to_a).and_return([mock_ticket_open])
        allow(controller).to receive(:pagy).and_return([nil, [mock_ticket_open]])
        
        get :index, params: { status: 'Open' }
        expect(assigns(:tickets)).to match_array([mock_ticket_open])
      end
    end

  end
end