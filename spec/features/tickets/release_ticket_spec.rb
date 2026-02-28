require 'rails_helper'

RSpec.describe 'Releasing a ticket', type: :feature do
  let(:org_user) { create(:user, :organization_approved) }
  let(:ticket) { create(:ticket, organization_id: org_user.organization_id) }

  before do
    log_in_as(org_user)
  end

  it 'can be released by the organization owning it' do
    visit ticket_path(ticket)
    click_on 'Release'
    
    expect(current_path).to eq dashboard_path
    expect(ticket.reload.organization_id).to be_nil
  end
end
