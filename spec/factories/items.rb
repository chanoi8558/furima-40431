FactoryBot.define do
  factory :item do
    name { '商品名' }
    description { '商品の説明' }
    category_id { 2 }
    condition_id { 2 }
    shipping_fee_id { 2 }
    prefecture_id { 2 }
    shipping_time_id { 2 }
    price { 300 }
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('spec/fixtures/test_image.png'), filename: 'test_image.png')
    end
  end
end