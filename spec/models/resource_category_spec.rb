require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do
    let (:resource_category) {ResourceCategory.new}

    it "responds to name" do
      expect(resource_category).to respond_to(:name)
    end
    it "responds to active" do
      expect(resource_category).to respond_to(:active)
    end

    it "has and belongs to many organizations" do
      should have_and_belong_to_many(:organizations)
    end

    it "has many tickets" do
      should have_many(:tickets)
    end

    describe "validation tests" do
      let (:resource_category) {ResourceCategory.new}  

      it ("must have a name") {should validate_presence_of(:name)}

      it "must have an name with a length of less than 256 and more than 0 on creation" do
        should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
      end

      it("name must be unique") {should validate_uniqueness_of(:name).case_insensitive}
      
    end

    describe "Unit tests" do
      let(:resourceCategory) do
        resource = ResourceCategory.new(name: "Water",
        active: true)
        resource.save(validate: false)
        resource
      end 

      it "can activate" do
        expect(resourceCategory.inactive?).to eq(false)
      end
      
      it "can deactivate" do
          resourceCategory.deactivate
          expect(resourceCategory.inactive?).to eq(true)
      end

      it "knows if it is inactive" do
          resourceCategory.deactivate
          expect(resourceCategory.inactive?).to eq(true)
      end

      it "converts to string" do
          expect(resourceCategory.to_s).to eq("Water")
      end

      it "defaults to unspecified" do
        resource = ResourceCategory.unspecified
        expect(resource.to_s).to eq("Unspecified")
      end
    end

    describe "Scope tests" do
      let(:active_resource) do
        resource = ResourceCategory.new(active: true)
        resource.save(validate: false)
        resource
      end

      let(:inactive_resource) do
        resource = ResourceCategory.new(active: false)
        resource.save(validate: false)
        resource
      end
    
      it "returns all active resource categories" do
        results = ResourceCategory.active
        expect(results).to include(active_resource)

        expect(results).not_to include(inactive_resource)
      end

      it "returns all inactive resource categories" do
          results = ResourceCategory.inactive
          expect(results).to include(inactive_resource)

          expect(results).not_to include(active_resource)
      end
    end
end
