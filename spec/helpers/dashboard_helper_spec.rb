require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the DashboardHelper. For example:
#
# describe DashboardHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe DashboardHelper, type: :helper do
  describe "helper function tests" do
  # Setting up example users
    let(:admin_user) {User.new(role: :admin)}

    let(:organization_submitted_user) do
      submitted_org = Organization.new(status: :submitted)
      user = User.new(organization: submitted_org)     
    end

    let(:organization_approved_user) do
      approved_org = Organization.new(status: :approved)
      user = User.new(organization: approved_org)
    end

    let(:regular_user) {User.new}

    # Actual Tests
    it "dashboard helper returns admin_dashboard if user is an admin" do
      expect(dashboard_for(admin_user)).to eq('admin_dashboard')
    end

    it "dashboard helper returns organization_submitted_dashbord if user has an organization with status submitted" do
      expect(dashboard_for(organization_submitted_user)).to eq('organization_submitted_dashboard')
    end

    it "dashboard helper returns organization_approved_dashbord if user has an organization with status approved" do
      expect(dashboard_for(organization_approved_user)).to eq('organization_approved_dashboard')
    end
    
    it "dashboard helper returns create_application_dashboard' if the user has no active organization application and is not an admin" do
      expect(dashboard_for(regular_user)).to eq('create_application_dashboard')
    end
  end
end
