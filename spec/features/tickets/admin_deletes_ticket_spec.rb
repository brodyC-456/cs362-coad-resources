require 'rails_helper'

RSpec.describe 'Deleting a Ticket', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:ticket) { create(:ticket) }

  before do
    log_in_as(admin)
  end

  it 'can be deleted by an admin' do
    ticket_id = ticket.id
    visit ticket_path(ticket)
    
    click_on 'Delete'
    
    expect(current_path).to eq dashboard_path
    expect(page).to have_content("Ticket #{ticket_id} was deleted.")
    expect(Ticket.exists?(ticket_id)).to be_falsey
  end
end
