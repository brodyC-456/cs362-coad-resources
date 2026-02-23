require 'rails_helper'

RSpec.describe RegionsController, type: :controller do

  describe 'as a logged out user' do

    let(:fake_region) { double('Region', id: 1) }
    before do
      allow(Region).to receive(:find).with(fake_region.id.to_s).and_return(fake_region)
      allow(controller).to receive(:current_user).and_return(nil)
    end

    # Index
    it {
      expect(get(:index)).to redirect_to new_user_session_path
    }

    # Show
    it {
        get(:show, params: {id: fake_region.id})
        expect(response).to redirect_to new_user_session_path
    }

    # New
    it {
      expect(get(:new)).to redirect_to new_user_session_path
    }

    # Create
    it {
      post(:create, params: {region: {name: 'Fake Region'}})
      expect(response).to redirect_to new_user_session_path
    }

    # Edit
    it {
        get(:edit, params: {id: fake_region.id})
        expect(response).to redirect_to new_user_session_path
    }

    # Update
    it {
        patch(:update, params: {id: fake_region.id, region: {name: 'Fake Region'}})
        expect(response).to redirect_to new_user_session_path
    }

    # Destroy
    it {
        delete(:destroy, params: {id: fake_region.id})
        expect(response).to redirect_to new_user_session_path
    }
  end
  
  describe 'as a logged in user' do

    let(:fake_region) { double('Region', id: 1) }
    let(:user) { create(:user) }
    before do 
      allow(Region).to receive(:find).with(fake_region.id.to_s).and_return(fake_region)
      sign_in user 
    end

    # Index
    it {
      expect(get(:index)).to redirect_to dashboard_path
    }

    # Show
    it {
        get(:show, params: {id: fake_region.id})
        expect(response).to redirect_to dashboard_path
    }

    # New
    it {
      expect(get(:new)).to redirect_to dashboard_path
    }

    # Create
    it {
      post(:create, params: {region: {name: 'Fake Region'}})
      expect(response).to redirect_to dashboard_path
    }

    # Edit
    it {
        get(:edit, params: {id: fake_region.id})
        expect(response).to redirect_to dashboard_path
    }

    # Update
    it {
        patch(:update, params: {id: fake_region.id, region: {name: 'Fake Region'}})
        expect(response).to redirect_to dashboard_path
    }

    # Destroy
    it {
        delete(:destroy, params: {id: fake_region.id})
        expect(response).to redirect_to dashboard_path
    }
  end

  describe 'as an admin' do
    let(:admin) { create(:user, :admin) }
    let(:region) { create(:region) }
    before { sign_in admin }

    # Index
    it {
      expect(get(:index)).to be_successful
    }

    # Show
    it {
        get(:show, params: {id: region.id})
        expect(response).to be_successful
    }

    # New
    it {
        expect(get(:new)).to be_successful
    }

    # Create
    it {
      post(:create, params: {region: {name: 'Fake Region'}})
      expect(response).to redirect_to regions_path
    }

    # Edit
    it {
        get(:edit, params: {id: region.id})
        expect(response).to be_successful
    }

    # Update
    it {
        patch(:update, params: {id: region.id, region: {name: 'Fake Region'}})
        expect(response).to redirect_to region
    }

    # Destroy
    it {
        delete(:destroy, params: {id: region.id})
        expect(response).to redirect_to regions_path
    }
  end
end