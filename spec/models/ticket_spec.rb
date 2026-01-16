require 'rails_helper'

RSpec.describe Ticket, type: :model do
    it "exists" do
        Ticket.new
    end

    let (:ticket) {Ticket.new}

    it "responds to name" do
        expect(ticket).to respond_to(:name)
    end

    it "belongs to region" do
        should belong_to(:region) # if the belongs_to is optionial, add ".optional"
    end

    # look into rspec matchers to find tests for assoc. types that aren't belongs_to

    

end