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

  it "creates an item" do
    merchant = FactoryBot.create(:merchant)
    item_params = {
                  "name": "value1",
                  "description": "value2",
                  "unit_price": 100.99,
                  "merchant_id": merchant.id # couldn't hardcode the number due to thousands of merchants being created through running tests
                  }

    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(response.status).to eq(201)

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
  end

  it "returns an error if any attribute is missing" do
    merchant = FactoryBot.create(:merchant)
    item_params = {
                  "name": "value1",
                  "unit_price": 100.99,
                  "merchant_id": merchant.id
                  }

    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response.status).to eq(422)
  end

  it "ignores any attributes sent by the user which are not allowed" do
    merchant = FactoryBot.create(:merchant)
    item_params = {
                  "name": "value1",
                  "description": "value2",
                  "unit_price": 100.99,
                  "merchant_id": merchant.id,
                  "fluffy_unicorn": "Sparkle Horn"
                  }

    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item).not_to eq(item_params[:fluffy_unicorn])
  end
end