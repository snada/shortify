FactoryGirl.define do
  factory :short_url do
    sequence(:url) { |n| "http://thisismyverylongurlnumber#{n}" }

    factory :short_url_https do
      sequence(:url) { |n| "https://thisismyverylongurlnumber#{n}" }
    end
    
    sequence(:slug) { |n| "slug#{n}"}
  end
end
