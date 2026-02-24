require 'rails_helper'

RSpec.describe TicketsHelper, type: :helper do
  describe "test phone number" do
    
    it "normalizes phone number format" do
      allow(PhonyRails).to receive(:normalize_number).with("123-456-7890", country_code: 'US').and_return("+1234567890")
      expect(helper.format_phone_number("123-456-7890")).to eq("+1234567890")
    end

    it "normalizes phone number format with +1 and parenthesis" do
      allow(PhonyRails).to receive(:normalize_number).with("+1 (555)-123-4567", country_code: 'US').and_return("+15551234567")
      expect(helper.format_phone_number("+1 (555)-123-4567")).to eq("+15551234567")
    end

    it "normalizes phone number format no dashes" do
      allow(PhonyRails).to receive(:normalize_number).with("123 456 7890", country_code: 'US').and_return("+1234567890")
      expect(helper.format_phone_number("123 456 7890")).to eq("+1234567890")
    end

    it "incorrect phone number input returns nil" do
      allow(PhonyRails).to receive(:normalize_number).with("one two three", country_code: 'US').and_return(nil)
      expect(helper.format_phone_number("one two three")).to eq(nil)
    end

  end
end
