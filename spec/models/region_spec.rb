require 'rails_helper'

RSpec.describe Region, type: :model do

  let (:region) {Region.new}

  it "has a name" do
    expect(region).to respond_to(:name)
  end

  describe "Unit tests" do 
    
    it "has a string representation that is its name" do
      name = 'Mt. Hood'
      region = Region.new(name: name)
      result = region.to_s

      expect(result).to eq("Mt. Hood")
    end

    it "creates region with unspecified name" do
      unspecified_region = Region.unspecified
      expect(unspecified_region.name).to eq("Unspecified")
    end
  end

  it "has many tickets" do
    should have_many(:tickets)
  end

  describe "validation tests" do
    let (:region) {Region.new}

    it ("must have a name") {should validate_presence_of(:name)}

    it "must have an name with a length of less than 256 and more than 0 on creation" do
      should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
    end

    it("name must be unique") {should validate_uniqueness_of(:name).case_insensitive}
  end

end
