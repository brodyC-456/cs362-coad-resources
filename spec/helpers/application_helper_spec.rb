require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'test full title' do
    let(:base_title) { 'Disaster Resource Network' }

    it 'works with no title' do
      expect(helper.full_title()).to eq(base_title)
    end

    it 'works with title' do
      expect(helper.full_title('title')).to eq("title | #{base_title}")
    end
  end
end
