FactoryBot.define do
  factory :ticket do
    name { generate(:name) } 
    phone { generate(:phone) }
    description { "This is a test ticket description." }
    closed {false}

    association :region
    association :resource_category
    organization {nil} #this might cause trouble

    trait :captured do
      association :organization
    end
    trait :closed do
      closed {true}
    end
  end
end
