require "rails_helper"

describe "Items API" do
  describe "gets all items" do 
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

  describe "updates an item" do
    it "updates the corresponding item with details provided by the user" do
      merchant_1 = FactoryBot.create(:merchant)
      merchant_2 = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)
      headers = {"CONTENT_TYPE" => "application/json"}

      request_body = {
        "name": "necklace",
        "description": "pearl necklace",
        "unit_price": 19.99,
        "merchant_id": merchant_2.id
      }

      patch "/api/v1/items/#{item_1.id}", headers: headers, params: JSON.generate({item: request_body})     

      item_1.reload

      expect(response).to be_successful

      expect(item_1.name).to eq("necklace")
      expect(item_1.description).to eq("pearl necklace")
      expect(item_1.unit_price).to eq(19.99)
      expect(item_1.merchant_id).to eq(merchant_2.id)
    end

    it "sends the expected response back with item updates" do
      merchant_1 = FactoryBot.create(:merchant)
      merchant_2 = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)
      headers = {"CONTENT_TYPE" => "application/json"}

      request_body = {
        "name": "necklace",
        "description": "pearl necklace",
        "unit_price": 19.99,
        "merchant_id": merchant_2.id
      }

      patch "/api/v1/items/#{item_1.id}", headers: headers, params: JSON.generate({item: request_body})     

      item_1.reload

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: :true)

      expect(item[:data][:attributes][:name]).to eq("necklace")
      expect(item[:data][:attributes][:description]).to eq("pearl necklace")
      expect(item[:data][:attributes][:unit_price]).to eq(19.99)
      expect(item[:data][:attributes][:merchant_id]).to eq(merchant_2.id)
    end


  end

  it "sends one item" do
    merchant = FactoryBot.create(:merchant)
    item = FactoryBot.create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: :true)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
  end
end