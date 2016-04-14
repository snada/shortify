FactoryGirl.define do
  factory :short_url do
    sequence(:url) { |n| "http://thisismyverylongurlnumber#{n}" }

    # TODO
    # Factory to rewrite once real slug logic is in place!
    sequence(:slug) { |n| "slug#{n}"}
  end
end
