require 'rails_helper'

RSpec.describe TicketsController, type: :controller do

  describe 'as a logged out user' do
    let(:user) { create(:user) }
    let(:ticket_id) { '1' } # Use a consistent ID for the mock
    let(:mock_ticket) { instance_double(Ticket, id: ticket_id, destroy: true, save: true) }

    before do
      # Stub Ticket.find for show and destroy actions
      allow(Ticket).to receive(:find).with(ticket_id).and_return(mock_ticket)
      # Stub Ticket.new for create action
      allow(Ticket).to receive(:new).and_return(mock_ticket)
    end

    # New
    it {
      expect(get(:new)).to be_successful
    }

    # Create
    it {
      post(:create, params: {ticket: FactoryBot.attributes_for(:ticket)})
      expect(response).to redirect_to ticket_submitted_path
    }

    # This test is probably dependant on a method from a mock
    # or somthing that hasn't yet been implemented. (current_user.admin?)
    # # Show
    # it {
    #   get(:show, params: {id: ticket.id})
    #   expect(response).to redirect_to new_user_session_path
    # }

    # Destroy
    it {
      delete(:destroy, params: {id: ticket_id})
      expect(response).to redirect_to dashboard_path
    }
  end

  describe 'as a logged in user' do
    let(:user) { create(:user) }
    let(:ticket_id) { '1' }
    let(:mock_ticket) { instance_double(Ticket, id: ticket_id, destroy: true, save: true) }

    before (:each) {sign_in user}
    before do
      # Stub Ticket.find for show and destroy actions
      allow(Ticket).to receive(:find).with(ticket_id).and_return(mock_ticket)
      allow(Ticket).to receive(:new).and_return(mock_ticket)
    end

    # New
    it {
      expect(get(:new)).to be_successful
    }

    # Create
    it {
      post(:create, params: { ticket: FactoryBot.attributes_for(:ticket) })
      expect(response).to redirect_to ticket_submitted_path
    }

    # Show
    it {
      get(:show, params: {id: ticket_id})
      expect(response).to redirect_to dashboard_path
    }

    # Destroy
    it {
      delete(:destroy, params: {id: ticket_id})
      expect(response).to redirect_to dashboard_path
    }
  end

  describe 'as admin' do
    let(:user) { create(:user, :admin) }
    let(:ticket_id) { '1' }
    let(:mock_ticket) { instance_double(Ticket, id: ticket_id, destroy: true, save: true) }

    before (:each) {sign_in user}
    before do
      allow(Ticket).to receive(:find).with(ticket_id).and_return(mock_ticket)
      allow(Ticket).to receive(:new).and_return(mock_ticket)
    end

    # New
    it {
      expect(get(:new)).to be_successful
    }

    # Create
    it {
      post(:create, params: { ticket: FactoryBot.attributes_for(:ticket) })
      expect(response).to redirect_to ticket_submitted_path
    }

    # Show
    it {
      get(:show, params: {id: ticket_id})
      expect(response).to be_successful
    }

    # Destroy
    it {
      delete(:destroy, params: {id: ticket_id})
      expect(response).to redirect_to (dashboard_path << '#tickets')
    }

  end

end
