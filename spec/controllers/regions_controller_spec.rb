require 'rails_helper'

RSpec.describe RegionsController, type: :controller do

  describe 'as a logged out user' do
    let (:user) { create(:user)}

    it "index redirects to new user session when logged out" do
      expect(get(:index)).to redirect_to new_user_session_path
    end
  end


  
  describe 'as a logged in user' do
    let (:user) { create(:user)}
    before (:each) {sign_in user}

    it 'index redirects to dashboard' do
      expect(get(:index)).to redirect_to dashboard_path
    end
  end

  describe 'as an admin' do
    let (:user) { create(:user, :admin)}
    before (:each) {sign_in user}
    it "index is successful" do
      expect(get(:index)).to be_successful
    end
  end
end
