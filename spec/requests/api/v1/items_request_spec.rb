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

    it "bad postman merchant id test" do
      merchant_1 = FactoryBot.create(:merchant)
      merchant_2 = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)
      headers = {"CONTENT_TYPE" => "application/json"}

      request_body = {
        "name": "necklace",
        "description": "pearl necklace",
        "unit_price": 19.99,
        "merchant_id": 0
      }

      patch "/api/v1/items/#{item_1.id}", headers: headers, params: JSON.generate({item: request_body})     

      item_1.reload

      expect(response).to_not be_successful

      item = JSON.parse(response.body, symbolize_names: :true)

      expect(response.status).to eq(404) 
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
      
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    end
  end

  describe "delete an item" do
    it "can delete an item" do
      merchant = FactoryBot.create(:merchant)
      item = FactoryBot.create(:item, merchant_id: merchant.id)
  
      expect(Item.count).to eq(1)
    
      delete "/api/v1/items/#{item.id}"
    
      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "destroys any INVOICE ITEMS where this was the only item on an invoice" do
      merchant = FactoryBot.create(:merchant)
      item = FactoryBot.create(:item, merchant_id: merchant.id)

      customer = FactoryBot.create(:customer)
      invoice = FactoryBot.create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
      invoice_item = FactoryBot.create(:invoice_item, item_id: item.id, invoice_id: invoice.id)

      expect(InvoiceItem.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(InvoiceItem.count).to eq(0)
      expect{InvoiceItem.find(invoice_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    # refactor needed on destroy_with_invoice_items_and_invoices method in item.rb to make this pass
    # xit "destroys any INVOICES where this was the only item on an invoice" do
    #   merchant = FactoryBot.create(:merchant)
    #   item = FactoryBot.create(:item, merchant_id: merchant.id)

    #   customer = FactoryBot.create(:customer)
    #   invoice = FactoryBot.create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
    #   invoice_item = FactoryBot.create(:invoice_item, item_id: item.id, invoice_id: invoice.id)

    #   expect(InvoiceItem.count).to eq(1)

    #   delete "/api/v1/items/#{item.id}"

    #   expect(response).to be_successful
    #   expect(InvoiceItem.count).to eq(0)
    #   expect{InvoiceItem.find(invoice_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    # end

    it "returns a 204 HTTP status code and nothing in the response body" do
      merchant = FactoryBot.create(:merchant)
      item = FactoryBot.create(:item, merchant_id: merchant.id)
    
      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(response.status).to eq (204)
      expect(response.body).to be_empty
    end
  end

  it "creates an item" do
    merchant = FactoryBot.create(:merchant)
    item_params = {
                  "name": "value1",
                  "description": "value2",
                  "unit_price": 100.99,
                  "merchant_id": merchant.id
                  }

    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(response.status).to eq(201)

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
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
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    expect(created_item).not_to eq(item_params[:fluffy_unicorn])
  end

  it "creates an item" do
    merchant = FactoryBot.create(:merchant)
    item_params = {
                  "name": "value1",
                  "description": "value2",
                  "unit_price": 100.99,
                  "merchant_id": merchant.id
                  }

    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(response.status).to eq(201)

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
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
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    expect(created_item).not_to eq(item_params[:fluffy_unicorn])
  end

  describe "get an item's merchant" do
    it "sends a merchant for a given item" do
      merchant = FactoryBot.create(:merchant)
      item = FactoryBot.create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful
      
      item_merchant = JSON.parse(response.body, symbolize_names: :true)

      expect(item_merchant[:data][:id]).to eq(merchant.id.to_s)
    end

    it "returns a 404 HTTP status code if item is not found" do
      get "/api/v1/items/1/merchant"

      expect(response).to_not be_successful
      expect(response.status).to eq (404)
    end
  end

  describe "get items based on search criteria" do
    describe "index action happy paths" do
      it "finds all items by name fragment" do
        merchant = FactoryBot.create(:merchant)
        item_1 = FactoryBot.create(:item, name: "Computer Item", merchant_id: merchant.id)
        item_2 = FactoryBot.create(:item, name: "Turing Item", merchant_id: merchant.id)
        item_3 = FactoryBot.create(:item, name: "Ring World Item", merchant_id: merchant.id)

        get "/api/v1/items/find_all?name=ring"

        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: :true)

        expect(items[:data].count).to eq(2)
        expect(items[:data].first[:attributes][:name]).to eq(item_3.name)
        expect(items[:data].second[:attributes][:name]).to eq(item_2.name)
      end

      it "finds all items by min and max price" do
        merchant = FactoryBot.create(:merchant)
        item_1 = FactoryBot.create(:item, unit_price: 3.99, merchant_id: merchant.id)
        item_2 = FactoryBot.create(:item, unit_price: 12.34, merchant_id: merchant.id)
        item_3 = FactoryBot.create(:item, unit_price: 100, merchant_id: merchant.id)

        get "/api/v1/items/find_all?min_price=4.99&max_price=99.99"

        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: :true)

        expect(items[:data].count).to eq(1)
        expect(items[:data].first[:attributes][:name]).to eq(item_2.name)
      end

      it "finds all items by min price" do
        merchant = FactoryBot.create(:merchant)
        item_1 = Item.create!(name: "Computer Item", description: "fsfsadfs", unit_price: 49.00, merchant_id: merchant.id)
        item_2 = Item.create!(name: "Turing Item", description: "fsfsadfs", unit_price: 75.55, merchant_id: merchant.id)
        item_3 = Item.create!(name: "Ring World Item", description: "fsfsadfs", unit_price: 100, merchant_id: merchant.id)

        get "/api/v1/items/find_all?min_price=50"

        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: :true)

        expect(items[:data].count).to eq(2)
        expect(items[:data].first[:attributes][:name]).to eq(item_3.name)
        expect(items[:data].second[:attributes][:name]).to eq(item_2.name)
      end

      it "finds all items by max price" do
        merchant = FactoryBot.create(:merchant)
        item_1 = Item.create!(name: "Computer Item", description: "fsfsadfs", unit_price: 49.00, merchant_id: merchant.id)
        item_2 = Item.create!(name: "Turing Item", description: "fsfsadfs", unit_price: 75.55, merchant_id: merchant.id)
        item_3 = Item.create!(name: "Ring World Item", description: "fsfsadfs", unit_price: 100, merchant_id: merchant.id)

        get "/api/v1/items/find_all?max_price=99.99"

        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: :true)

        expect(items[:data].count).to eq(2)
        expect(items[:data].first[:attributes][:name]).to eq(item_1.name)
        expect(items[:data].second[:attributes][:name]).to eq(item_2.name)
      end
    end

    describe "index action sad paths - no item found" do
      it "sad path, no param given" do
        get "/api/v1/items/find_all?"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "sad path, empty param given" do
        get "/api/v1/items/find_all?name="

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "sad path, no item found by name fragment" do
        get "/api/v1/items/find_all?name=q"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "sad path, no item found by min and max price" do
        get "/api/v1/merchants/merchant_items?min_price=1000&max_price=1"
    
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end

      it "sad path, no item found by min price" do
        get "/api/v1/merchants/merchant_items?min_price=10000"
    
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end

      it "sad path, no item found by max price" do
        get "/api/v1/merchants/merchant_items?max_price=1"
    
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end
    end

    describe "index action sad paths - less than 0" do
      it "sad path, min price is less than 0" do
        get "/api/v1/items/find_all?min_price=-49"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "sad path, max price is less than 0" do
        get "/api/v1/items/find_all?max_price=-49"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end
    end

    describe "index action sad paths - sent too many criteria" do
      it "sad path, cannot send name and min price" do
        get "/api/v1/items/find_all?name=ring&min_price=49.00"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "sad path, cannot send name and max price" do
        get "/api/v1/items/find_all?name=ring&max_price=55.00"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end
    end
  end
end
