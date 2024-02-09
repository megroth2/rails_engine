FactoryBot.define do
  factory :customer do
    first_name {Faker::Name.first_name}
    last_name {Faker::Dessert.variety}
  end

  factory :merchant do
    name {Faker::Space.galaxy}
  end

  factory :item do
    name {Faker::Coffee.variety}
    description {Faker::Hipster.sentence}
    unit_price {Faker::Number.decimal(l_digits: 2)}
    merchant
  end

  factory :transaction do
    result {["failed", "success"].sample}
    credit_card_number {Faker::Finance.credit_card}
    credit_card_expiration_date {Faker::Date}
    invoice
  end

  factory :invoice_item do
    quantity {[1,2,3,4,5].sample}
    unit_price {Faker::Commerce.price}
    invoice
    item
  end

  factory :invoice do
    status {"shipped"}
    merchant
    customer
  end

end