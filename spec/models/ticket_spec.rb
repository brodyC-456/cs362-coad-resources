require 'rails_helper'

RSpec.describe Ticket, type: :model do

    #I had AI help with the shared attrs because I was pulling my non-existent hair out with those errors
    before(:each) do
        @organization = create(:organization)
        @other_organization = create(:organization)
        @region = create(:region)
        @category = create(:resource_category)
        @other_region = create(:region, name: "other_region")
        @other_category = create(:resource_category)

        shared_region_and_category = { region: @region, resource_category: @category }

        @ticket = create(:ticket, **shared_region_and_category) 
        @ticket_open = create(:ticket, **shared_region_and_category)
        @ticket_closed = create(:ticket, :closed, **shared_region_and_category)
        @ticket_captured = create(:ticket, :captured, organization: @organization, **shared_region_and_category)
        @ticket_closed_captured = create(:ticket, :closed, :captured, organization: @organization, **shared_region_and_category)
        @other_org_ticket = create(:ticket, closed: false, organization: @other_organization, **shared_region_and_category)

        #not sharing attributes
        @other_ticket = create(:ticket, region: @region, resource_category: @other_category)
        @other_region_ticket = create(:ticket, region: @other_region, resource_category: @category)
    end

        describe "when checking for attributes" do
            it "has a name" do
                expect(@ticket).to respond_to(:name)
            end

            it "has a description" do
                expect(@ticket).to respond_to(:description)
            end

            it "has a phone number" do
                expect(@ticket).to respond_to(:phone)
            end

            it "knows if it is closed" do
                expect(@ticket).to respond_to(:closed)
            end

            it "knows when it was closed" do
                expect(@ticket).to respond_to(:closed_at)
            end
        end

        describe "when checking for associations" do
            it "belongs to region" do
                should belong_to(:region)
            end

            it "belongs to resource category" do
                should belong_to(:resource_category)
            end

            it "belongs to organization" do
                should belong_to(:organization).optional
            end
        end

    # Validation Tests
    describe "when checking validations" do
      let (:ticket) {build(:ticket)}

      it ("must have a name") {should validate_presence_of(:name)}
      it ("must have a phone number") {should validate_presence_of(:phone)}
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
    describe "when checking member functions" do
        it "converts to a string" do
            expect(@ticket_captured.to_s).to eq "Ticket #{@ticket_captured.id}"
        end

        it "recognizes when an organization owns it" do
            expect(@ticket_captured.captured?).to be true
        end

        it "recognizes when an organization doesn't own it" do
            expect(@ticket.captured?).to be false
        end
    end

    # Scope Tests
    describe "when checking scope" do

    # Replace with factory to create valid tickets instead of putting bad tickets into the test DB

        it "returns only open tickets" do
            results = Ticket.open
            expect(results).to include(@ticket_open)

            expect(results).not_to include(@ticket_closed)
            expect(results).not_to include(@ticket_closed_captured)
            expect(results).not_to include(@ticket_captured)
        end

        it "returns only closed tickets" do
            results = Ticket.closed
            expect(results).to include(@ticket_closed)

            expect(results).not_to include(@ticket_open)
            expect(results).not_to include(@ticket_captured)
            #expect(results).not_to include(@ticket_closed_captured) #I'm not sure if the expected behavior is to have captured tickets excluded
        end

        it "returns only captured tickets" do
          results = Ticket.all_organization

          expect(results).to include(@ticket_captured)

          expect(results).not_to include(@ticket_open)
          expect(results).not_to include(@ticket_closed)
          expect(results).not_to include(@ticket_closed_captured)
        end

        describe "when checking organization scoping" do
        let(:other_organization) { create(:organization) }
        let(:other_org_ticket) { create(:ticket, closed: false, organization: other_organization) }

        it "returns only open tickets for a specific organization" do
          results = Ticket.organization(@organization.id)

          expect(results).to include(@ticket_captured)

          expect(results).not_to include(@ticket_closed_captured)
          expect(results).not_to include(@other_org_ticket)
        end

        it "returns only tickets closed for an organization" do
          results = Ticket.closed_organization(@organization.id)

          expect(results).to include(@ticket_closed_captured)

          expect(results).not_to include(@ticket_captured)
          expect(results).not_to include(@other_org_ticket)
        end

        it "does not return tickets from other organizations" do
          results = Ticket.organization(@organization.id)

          expect(results).to include(@ticket_captured)

          expect(results).not_to include(@other_org_ticket)
        end

        end

        describe "when checking region scoping" do

            it "returns all tickets for a specific region" do 
              results = Ticket.region(@region.id)

              expect(results).to include(@ticket)

              expect(results).not_to include(@other_region_ticket)
            end
        end

        describe "when checking resource category scoping" do

            it "returns all tickets for a specific cateogry id" do
                results = Ticket.resource_category(@category.id)

                expect(results).to include(@ticket)

                expect(results).not_to include(@other_ticket)
            end
        end
    end
end