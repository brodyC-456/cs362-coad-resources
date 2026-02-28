require 'rails_helper'

RSpec.describe 'Closing a ticket', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:org_user) { create(:user, :organization_approved) }
  let(:ticket) { create(:ticket, organization_id: org_user.organization_id) }

  it 'can be closed by an admin' do
    log_in_as(admin)
    visit ticket_path(ticket)
    click_on 'Close'
    
    expect(current_path).to eq dashboard_path
    expect(ticket.reload.closed).to be_truthy
    expect(ticket.closed_at).to be_present
  end

  it 'can be closed by the organization owning it' do
    log_in_as(org_user)
    visit ticket_path(ticket)
    click_on 'Close'
    
    expect(current_path).to eq dashboard_path
    expect(ticket.reload.closed).to be_truthy
    expect(ticket.closed_at).to be_present
  end
end
