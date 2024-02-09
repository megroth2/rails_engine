require 'rails_helper'

RSpec.describe Merchant do
  describe "associations" do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe "#find_merchant_by_name" do
    it "finds the first merchant in case-insensitive alphabetical order that matches a user-provided name fragment" do
      merchant_1 = Merchant.create(name: "Computers R' Us")
      merchant_2 = Merchant.create(name: "Turing")
      merchant_3 = Merchant.create(name: "Ring World")

      expect(Merchant.find_merchant_by_name("ring")).to eq(merchant_3)
    end
  end
end