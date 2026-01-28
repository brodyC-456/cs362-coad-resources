require 'rails_helper'

RSpec.describe User, type: :model do

  let (:user) {User.new}

  it "responds to email" do
    expect(user).to respond_to(:email)
  end

  it "responds to role" do
    expect(user).to respond_to(:role)
  end

  it "belongs to organization" do
    should belong_to(:organization).optional
  end

  describe "validation tests" do
    let (:user) {User.new}

    it ("must have an email") {should validate_presence_of(:email)}
    it ("must have a password") {should validate_presence_of(:password).on(:create)}

    it "must have an email with a length of less than 256 and more than 0 on creation" do
      should validate_length_of(:email).is_at_least(1).is_at_most(255).on(:create)
    end

    it "must have a password with a length of at least 7 and at most 255 on creation" do
      should validate_length_of(:password).is_at_least(7).is_at_most(255).on(:create)
    end

    it "email must have a valid format" do 
      should allow_value('john.doe+test-123@example-domain.com').for(:email)
      should_not allow_value('foo bar').for(:email)
    end

    it("email must be unique") {should validate_uniqueness_of(:email).case_insensitive}

  end

  describe "Unit tests" do

    let(:default_user) do
      org = Organization.new
      user = User.new(organization: org,
      email: "HuntersMom@aol.com")
      user.save(validate: false)
      user
    end

    it "defaults to organization as role" do
      expect(default_user.role).to eq("organization") #this method does not seem useful
    end

    it "converts to email address" do
      expect(default_user.to_s).to eq("HuntersMom@aol.com")
    end
  end

  describe "helper function tests" do
    include DashboardHelper

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
