require "rails_helper"

describe "Merchants API" do
  describe "get all merchants" do
    it "sends a list of merchants" do
      FactoryBot.create_list(:merchant, 10)

      get "/api/v1/merchants"

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: :true)

      expect(merchants[:data].count).to eq(10)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
        
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it "returns an array even if zero merchants are found" do
      get "/api/v1/merchants"

      merchants = JSON.parse(response.body, symbolize_names: :true)

      expect(merchants[:data].count).to eq(0)
      expect(merchants[:data]).to eq([])
    end

    it "returns an array even if one merchant is found" do
      FactoryBot.create(:merchant)

      get "/api/v1/merchants"

      merchants = JSON.parse(response.body, symbolize_names: :true)

      expect(merchants[:data].count).to eq(1)
      expect(merchants[:data]).to be_an(Array)
    end

    it "does not include dependent data of the resource" do
      FactoryBot.create_list(:merchant, 10)

      get "/api/v1/merchants"

      merchants = JSON.parse(response.body, symbolize_names: :true)

      merchants[:data].each do |merchant|
        expect(merchant).to_not have_key(:invoice)
        expect(merchant).to_not have_key(:item)
      end
    end
  end

  describe "get one merchant" do
    it "sends one merchant" do
      merchant = FactoryBot.create(:merchant)

      get "/api/v1/merchants/#{merchant.id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: :true)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe "get a merchant's items" do
    it "sends a list of items for a given merchant" do
      merchant = FactoryBot.create(:merchant)
      merchant_items = FactoryBot.create_list(:item, 10, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful
      merchant_items = JSON.parse(response.body, symbolize_names: :true)

      expect(merchant_items[:data].count).to eq(10)
    end

    it "does NOT send items from another merchant" do
      merchant_1 = FactoryBot.create(:merchant)
      merchant_2 = FactoryBot.create(:merchant)

      merchant_1_items = FactoryBot.create_list(:item, 6, merchant_id: merchant_1.id)
      merchant_2_items = FactoryBot.create_list(:item, 3, merchant_id: merchant_2.id)

      get "/api/v1/merchants/#{merchant_1.id}/items"
      
      expect(response).to be_successful
      merchant_items = JSON.parse(response.body, symbolize_names: :true)
      
      expect(merchant_items[:data].count).to eq(6)

      get "/api/v1/merchants/#{merchant_2.id}/items"

      expect(response).to be_successful
      merchant_items = JSON.parse(response.body, symbolize_names: :true)

      expect(merchant_items[:data].count).to eq(3)
    end

    it "returns a 404 HTTP status code if merchant is not found" do
      get "/api/v1/merchants/1/items"

      expect(response).to_not be_successful
      expect(response.status).to eq (404)
    end
  end

  describe "merchant 'find one' endpoints" do
    it "returns a single object, if found" do
      merchant_1 = Merchant.create(name: "Computers R' Us")
      merchant_2 = Merchant.create(name: "Turing")
      merchant_3 = Merchant.create(name: "Ring World")

      get "/api/vi/merchants/find?name=ring"

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: :true)

      # return a single object, if found
      expect(merchants[:data].count).to eq(1)
      # return the first object in the database in case-insensitive alphabetical order
      # if multiple matches are found
      # expect(merchants[:data].count).to eq(1)
      
      # get "/api/vi/merchants/find?name=ring"

    end
  end
end