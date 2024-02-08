require "rails_helper"

describe "Items API" do
  describe "get all items" do
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

  describe "get one item" do
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

  describe "delete an item" do
    it "can delete an item" do # destroys the corresponsing record and any associated data
      merchant = FactoryBot.create(:merchant)
      item = FactoryBot.create(:item, merchant_id: merchant.id)
  
      expect(Item.count).to eq(1)
    
      delete "/api/v1/items/#{item.id}"
    
      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "destroys any invoice where this was the only item on an invoice" do
      merchant = FactoryBot.create(:merchant)
      item = FactoryBot.create(:item, merchant_id: merchant.id)

      customer = FactoryBot.create(:customer)
      invoice = FactoryBot.create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
      invoice_item = FactoryBot.create(:invoice_item, item_id: item.id, invoice_id: invoice.id)

      expect(Invoice.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Invoice.count).to eq(0)
      expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    xit "returns a 204 HTTP status code" do

    end

    xit "doesn't return any JSON body" do

    end
  end
end