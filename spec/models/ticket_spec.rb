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
        let (:organization) {Organization.new}
        let (:ticket_123) {Ticket.new(id: 123,
         organization: organization)}

         let (:ticket_unowned) {Ticket.new(id: 456,
         organization: nil)}

        it "converts to a string" do
            expect(ticket_123.to_s).to eq "Ticket 123"
        end

        it "recognizes when an organization owns it" do
            expect(ticket_123.captured?).to be true
        end

        it "recognizes when an organization doesn't own it" do
            expect(ticket_unowned.captured?).to be false
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
            t = Ticket.new(closed: true)
            t.save(validate: false)
            t
        end

        it "scopes open tickets" do
            expect(Ticket.open).to include(ticket_open)
        end
        
        it "scopes closed ticket" do
            expect(Ticket.closed).to include(ticket_closed)
        end

        it "absolutely fails" do
            raise "if you see this, docker sees your files"
        end
    end
end