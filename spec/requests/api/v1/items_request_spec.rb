require "rails_helper"

describe "Items API" do
  it "sends a list of items" do
    merchant = FactoryBot.create(:merchant)
    FactoryBot.create_list(:item, 10, merchant_id: merchant.id)

    get "/api/v1/items"

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: :true)

    expect(items[:data].count).to eq(10)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it "returns an array even if zero items are found" do
    get "/api/v1/items"

    items = JSON.parse(response.body, symbolize_names: :true)

    expect(items[:data].count).to eq(0)
    expect(items[:data]).to eq([])
  end

  it "returns an array even if one item is found" do
    merchant = FactoryBot.create(:merchant)
    FactoryBot.create(:item, merchant_id: merchant.id)

    get "/api/v1/items"

    items = JSON.parse(response.body, symbolize_names: :true)

    expect(items[:data].count).to eq(1)
    expect(items[:data]).to be_an(Array)
  end

  it "does not include dependent data of the resource" do
    merchant = FactoryBot.create(:merchant)
    FactoryBot.create_list(:item, 10, merchant_id: merchant.id)

    get "/api/v1/items"

    items = JSON.parse(response.body, symbolize_names: :true)

    items[:data].each do |item|
      expect(items).to_not have_key(:merchant_name)
      expect(items).to_not have_key(:item)
    end
  end
end