require "rails_helper"

describe "Merchants API" do
  it "sends a list of merchants" do

    get "/api/v1/merchants"

    expect(response).to be_successful
# require 'pry'; binding.pry
    merchants = JSON.parse(response.body, symbolize_names: :true)

    expect(merchants.count).to eq(100)
  end
end