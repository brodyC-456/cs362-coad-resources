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

    # Validation Tests
    describe "validation tests" do
      let (:ticket) {Ticket.new}

      it ("must have a name") {should validate_presence_of(:name)}
      it ("must have a phone") {should validate_presence_of(:phone)}
      it ("must have a region id") {should validate_presence_of(:region_id)}
      it ("must have a resource category id") {should validate_presence_of(:resource_category_id)}

      it "must have a name with a length of less than 255 and more than 1 on creation" do
        should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
      end

      it "cannot have a description with a length of more than 1020 on create" do
        should validate_length_of(:description).is_at_most(1020).on(:create)
      end

      it ("must validate phone numbers") {should allow_value('+1-555-555-5555').for(:phone)}
    end

    # Member Function Tests
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

    # Scope Tests
    describe "Scope tests" do

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

        let(:organization_1) do
          org = Organization.new
          org.save(validate: false)
          org
        end

        let(:organization_2) do
          org = Organization.new
          org.save(validate: false)
          org
        end

        let(:ticket_closed_captured) do 
            t = Ticket.new(closed: true,
            organization: organization_1)
            t.save(validate: false)
            t
        end
        let(:ticket_open_captured) do 
            t = Ticket.new(closed: false,
            organization: organization_2)
            t.save(validate: false)
            t
        end

        it "returns all open tickets" do
            results = Ticket.open
            expect(results).to include(ticket_open)

            expect(results).not_to include(ticket_closed)
            expect(results).not_to include(ticket_closed_captured)
            expect(results).not_to include(ticket_open_captured)
        end
        
        it "it returns all closed ticket" do
            results = Ticket.closed
            expect(results).to include(ticket_closed)

            expect(results).not_to include(ticket_open)
            expect(results).not_to include(ticket_open_captured)
            expect(results).not_to include(ticket_closed_captured)
        end

        it "scopes all organizations" do
          results = Ticket.all_organization

          expect(results).to include(ticket_open_captured)

          expect(results).not_to include(ticket_open)
          expect(results).not_to include(ticket_closed)
          expect(results).not_to include(ticket_closed_captured)
        end

        describe "Organization scoping" do
        let(:org) do
            o = Organization.new
            o.save(validate: false)
            o
        end

        let(:matching_ticket) do
          t = Ticket.new(
            closed: false,
            organization: org
          )
          t.save(validate: false)
          t
        end

        let(:closed_ticket) do
          t = Ticket.new(
            closed: true,
            organization: org
          )
          t.save(validate: false)
          t
        end

        let(:other_org_ticket) do
            other = Organization.new
            other.save(validate: false)

            t = Ticket.new(
                closed: false,
                organization: other
            )
            t.save(validate: false)
            t
        end

        it "returns open tickets for a specific organization" do
          results = Ticket.organization(org.id)

          expect(results).to include(matching_ticket)

          expect(results).not_to include(closed_ticket)
          expect(results).not_to include(other_org_ticket)
        end

        it "returns tickets closed for an organization" do
          results = Ticket.closed_organization(org.id)

          expect(results).to include(closed_ticket)

          expect(results).not_to include(matching_ticket)
          expect(results).not_to include(other_org_ticket)
        end

        it "does not return tickets from other organizations" do
          results = Ticket.organization(org.id)
          
          expect(results).to include(matching_ticket)

          expect(results).not_to include(other_org_ticket)
        end

        end

        describe "Region scoping" do
            let(:region) do
                r = Region.new
                r.save(validate: false)
                r
            end

            let(:matching_ticket) do
              t = Ticket.new(region: region)
              t.save(validate: false)
              t
            end

            let(:other_ticket) do
                r = Region.new
                r.save(validate: false)

                t = Ticket.new(region: r)
                t.save(validate: false)
                t
            end

            it "filters by region" do
              results = Ticket.region(region.id)

              expect(results).to include(matching_ticket)

              expect(results).not_to include(other_ticket)
            end
        end

        describe "Resource Category scoping" do
            let(:category) do
                c = ResourceCategory.new
                c.save(validate: false)
                c
            end 

            let(:matching_ticket) do
                t = Ticket.new(resource_category: category)
                t.save(validate: false)
                t
            end

            let(:other_ticket) do
                c = ResourceCategory.new
                c.save(validate: false)
                
                t = Ticket.new(resource_category: c)
                t.save(validate: false)
                t
            end

            it "filters tickets by resource category" do
                results = Ticket.resource_category(category.id)

                expect(results).to include(matching_ticket)

                expect(results).not_to include(other_ticket)
            end
        end
    end
end