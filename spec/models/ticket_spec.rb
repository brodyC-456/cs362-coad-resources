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

    describe "Member function tests" do
        let (:ticket_123) {Ticket.new(id: 123)}

        it "converts to a string" do
            expect(ticker_123.to_s).to eq "Ticket 123"
        end
    end

    describe "Scope test" do

        # Replace with factory to create valid tickets instead of putting bad tickets into the test DB
        let(:ticket_open) do
            t = Ticket.new
            t.save(validate: false)
            t
        end
        let(:ticket_closed) do 
            t = Ticker.new(closed: true)
            t.save(validate: false)
            t
        end

        it "scopes open tickets" do
            expect(Ticket.open).to include(ticket_open)
        end
        
        it "scopes closed ticket" do
            expect(Ticket.closed).to include(ticket_closed)
        end
    end
end