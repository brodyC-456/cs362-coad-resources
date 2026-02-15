require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #index" do
    it "returns a http success" do
      # RIGHT: The action must happen here
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
