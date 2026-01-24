require 'rails_helper'

RSpec.describe Organization, type: :model do
  let (:organization) {Organization.new}

  describe "Validation Tests" do
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
  end
  
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
end
