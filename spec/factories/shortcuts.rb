FactoryGirl.define do
  factory :shortcut do
    sequence(:url) { |n| "http://thisismyverylongurlnumber#{n}" }

    factory :shortcut_https do
      sequence(:url) { |n| "https://thisismyverylongurlnumber#{n}" }
    end

    sequence(:slug) { |n| "slug#{n}"}
  end
end
