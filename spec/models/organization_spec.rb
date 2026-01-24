require 'rails_helper'

RSpec.describe Organization, type: :model do
  let (:organization) {Organization.new}
  
  describe "Unit Tests" do
        let(:local_fire_department) do
            org = Organization.new(status: :approved, name: "Bend Fire Department")
            org.save(validate: false)
            org
        end

        let(:rejected_org) do
            org = Organization.new(status: :rejected)
            org.save(validate: false)
            org
        end

        let(:default_org) do
            org = Organization.new
            org.save(validate: false)
            org
        end

        it "converts to a string" do
          expect(local_fire_department.to_s).to eq("Bend Fire Department") 
        end

        it "changes it's status when approved" do
          rejected_org.approve
          expect(rejected_org.status).to eq("approved")
        end

        it "changes it's status when rejected" do
            local_fire_department.reject
            expect(local_fire_department.status).to eq("rejected")
        end

        it "defaults to submitted status" do
            expect(default_org.status).to eq("submitted")
        end
  end

  it "responds to title" do
    expect(organization).to respond_to(:title)
  end

  it "responds to transportation" do
    expect(organization).to respond_to(:transportation)
  end

  it "has many users" do
    should have_many(:users) 
  end

  it "has many tickets" do
    should have_many(:tickets) 
  end

  it "has and belongs to many resource categories" do
    should have_and_belong_to_many(:resource_categories) 
  end

  # Validation Tests
  describe "validation tests" do
    let (:organization) {Organization.new}
    it "responds to name" do
      expect(organization).to respond_to(:name)
    end
    it "responds to status" do
      expect(organization).to respond_to(:status)
    end
    
    it "responds to phone" do
      expect(organization).to respond_to(:phone)
    end
    it "responds to email" do
      expect(organization).to respond_to(:email)
    end
    it "responds to description" do
      expect(organization).to respond_to(:description)
    end
    it "responds to rejection_reason" do
      expect(organization).to respond_to(:rejection_reason)
    end
    it "responds to liability_insurance" do
      expect(organization).to respond_to(:liability_insurance)
    end
    
    it "responds to primary_name" do
      expect(organization).to respond_to(:primary_name)
    end
    it "responds to secondary_name" do
      expect(organization).to respond_to(:secondary_name)
    end
    it "responds to secondary_phone" do
      expect(organization).to respond_to(:secondary_phone)
    end
    it "responds to title" do
      expect(organization).to respond_to(:title)
    end
    it "responds to transportation" do
      expect(organization).to respond_to(:transportation)
    end
    it "has many users" do
      should have_many(:users)
    end
    it "has many tickets" do
      should have_many(:tickets)
    end
    it "has and belongs to many resource categories" do
      should have_and_belong_to_many(:resource_categories)
    end

    it ("must have an email") {should validate_presence_of(:email)}
    it ("must have a name") {should validate_presence_of(:name)}
    it ("must have a phone") {should validate_presence_of(:phone)}
    it ("must have a status") {should validate_presence_of(:status)}
    it ("must have a primary name") {should validate_presence_of(:primary_name)}
    it ("must have a secondary name") {should validate_presence_of(:secondary_name)}
    it ("must have a secondary phone") {should validate_presence_of(:secondary_phone)}

    it "must have an email with a length of less than 256 and more than 0 on creation" do
        should validate_length_of(:email).is_at_least(1).is_at_most(255).on(:create)
    end

    it "must have an name with a length of less than 256 and more than 0 on creation" do
        should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
    end

    it "must have a description with a length of, at most, 1020" do
        should validate_length_of(:description).is_at_most(1020).on(:create)
    end

    it "email must have a valid format" do 
      should allow_value('john.doe+test-123@example-domain.com').for(:email)
      should_not allow_value('foo bar').for(:email)
    end

    it("email must be unique") {should validate_uniqueness_of(:email).case_insensitive}
    it("name must be unique") {should validate_uniqueness_of(:name).case_insensitive}

  end
  
end
