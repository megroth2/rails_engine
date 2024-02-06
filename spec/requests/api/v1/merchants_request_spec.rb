require "rails_helper"

describe "Merchants API" do
  it "sends a list of merchants" do
    FactoryBot.create_list(:merchant, 100)

    get "/api/v1/merchants"

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: :true)

    expect(merchants.count).to eq(100)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it "returns an array even if zero merchants are found" do
    get "/api/v1/merchants"

    merchants = JSON.parse(response.body, symbolize_names: :true)

    expect(merchants.count).to eq(0)
    expect(merchants).to eq([])
  end

  it "returns an array even if one merchant is found" do
    FactoryBot.create(:merchant)

    get "/api/v1/merchants"

    merchants = JSON.parse(response.body, symbolize_names: :true)

    expect(merchants.count).to eq(1)
    expect(merchants).to be_an(Array)
  end

  it "does not include dependent data of the resource" do
    FactoryBot.create_list(:merchant, 10)

    get "/api/v1/merchants"

    merchants = JSON.parse(response.body, symbolize_names: :true)

    merchants.each do |merchant|
      expect(merchant).to_not have_key(:invoice)
      expect(merchant).to_not have_key(:item)
    end
  end
end