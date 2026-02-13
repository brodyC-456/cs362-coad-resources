require 'rails_helper'

RSpec.describe TicketsController, type: :controller do

  describe 'as a logged out user' do
    let (:user) {create(:user)}
    let (:ticket) {create(:ticket)}

    # New
    it {
      expect(get(:new)).to be_successful
    }

    # Create
    it {
      post(:create, params: {ticket: FactoryBot.attributes_for(:ticket)})
      expect(response).to be_successful
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
      delete(:destroy, params: {id: ticket.id})
      expect(response).to redirect_to dashboard_path
    }
  end

  describe 'as a logged in user' do
    let (:user) {create(:user)}
    let (:ticket) {create(:ticket)}
    before (:each) {sign_in user}

    # New
    it {
      expect(get(:new)).to be_successful
    }

    # Create
    it {
      post(:create, params: {ticket: FactoryBot.attributes_for(:ticket)})
      expect(response).to be_successful
    }

    # Show
    it {
      get(:show, params: {id: ticket.id})
      expect(response).to redirect_to dashboard_path
    }

    # Destroy
    it {
      delete(:destroy, params: {id: ticket.id})
      expect(response).to redirect_to dashboard_path
    }
  end

  describe 'as admin' do
    let (:user) {create(:user, :admin)}
    let (:ticket) {create(:ticket)}
    before (:each) {sign_in user}

    # New
    it {
      expect(get(:new)).to be_successful
    }

    # Create
    it {
      post(:create, params: {ticket: FactoryBot.attributes_for(:ticket)})
      expect(response).to be_successful
    }

    # Show
    it {
      get(:show, params: {id: ticket.id})
      expect(response).to be_successful
    }

    # Destroy
    it {
      delete(:destroy, params: {id: ticket.id})
      expect(response).to redirect_to (dashboard_path << '#tickets')
    }

  end

end
