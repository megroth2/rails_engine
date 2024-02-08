require "rails_helper"

describe "Merchants API" do
  it "sends a list of merchants" do
    FactoryBot.create_list(:merchant, 100)

    get "/api/v1/merchants"

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: :true)

    expect(merchants[:data].count).to eq(100)

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