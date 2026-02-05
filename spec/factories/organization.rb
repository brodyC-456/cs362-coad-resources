FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organization Name #{n}" }
    sequence(:email) { |n| "org#{n}@example.com" }
    phone { "555-123-4567" }
    status { :submitted } # Default status, can be overridden
    primary_name { "Primary Contact" }
    secondary_name { "Secondary Contact" }
    secondary_phone { "555-987-6543" }
  end
end