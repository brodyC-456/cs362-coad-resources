FactoryBot.define do
    sequence :name do |n|
      "fakename_#{n}"
    end

    sequence :email do |n|
      "fakeuser#{n}@fakedomain#{n}.com"
    end

    # I was having issues with the phone number sequence being invalid so I had AI fix it.
    sequence :phone do |n|
    "+1541700#{n.to_s.rjust(4, "0")}"
  end

end