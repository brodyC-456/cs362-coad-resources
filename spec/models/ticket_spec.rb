require 'rails_helper'

RSpec.describe Ticket, type: :model do

    let (:ticket) {Ticket.new}

    it "responds to name" do
        expect(ticket).to respond_to(:name)
    end

    it "responds to description" do
        expect(ticket).to respond_to(:description)
    end

    it "responds to phone" do
        expect(ticket).to respond_to(:phone)
    end

    it "responds to closed" do
        expect(ticket).to respond_to(:closed)
    end

    it "responds to closed_at" do
        expect(ticket).to respond_to(:closed_at)
    end

    it "belongs to region" do
        should belong_to(:region) # if the belongs_to is optionial, add ".optional"
    end

    it "belongs to resource category" do
        should belong_to(:region) 
    end

    it "belongs to resource category" do
        should belong_to(:resource_category) 
    end

    it "belongs to organization" do
        should belong_to(:organization).optional 
    end
end