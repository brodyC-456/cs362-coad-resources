require 'rails_helper'

RSpec.describe 'Capturing a ticket', type: :feature do
  let(:user) { create(:user, :organization_approved) }
  let(:ticket) { create(:ticket) }

  before do
    log_in_as(user)
  end

  it 'can be captured by an approved organization user' do
    visit ticket_path(ticket)
    click_on 'Capture'

    expect(current_path).to eq dashboard_path
    # the controller appends #tickets:open to the path, 
    # but current_path doesn't include the fragment.
    
    expect(ticket.reload.organization_id).to eq user.organization_id
  end
end
