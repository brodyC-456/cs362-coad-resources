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

end
