require 'rails_helper'

RSpec.describe Item do
  describe "associations" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many :invoices }
  end

  describe "#destroy_with_invoice_items_and_invoices" do
    it "destroys item with invoice items and invoices" do 
      merchant = FactoryBot.create(:merchant)
      item = FactoryBot.create(:item, merchant_id: merchant.id)

      customer = FactoryBot.create(:customer)
      invoice = FactoryBot.create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
      invoice_item = FactoryBot.create(:invoice_item, item_id: item.id, invoice_id: invoice.id)

      expect(Item.count).to eq(1)
      expect(InvoiceItem.count).to eq(1)
      expect(Invoice.count).to eq(1)

      item.destroy_with_invoice_items_and_invoices

      expect(Item.count).to eq(0)
      expect(InvoiceItem.count).to eq(0)
      expect(Invoice.count).to eq(0)
    end

    # xit "doesn't destroy invoices if there's more than one item on the invoice" do
    #   merchant = FactoryBot.create(:merchant)
    #   item_1 = FactoryBot.create(:item, merchant_id: merchant.id)
    #   item_2 = FactoryBot.create(:item, merchant_id: merchant.id)

    #   customer = FactoryBot.create(:customer)
    #   invoice = FactoryBot.create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
    #   invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item_1.id, invoice_id: invoice.id)
    #   invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item_2.id, invoice_id: invoice.id)

    #   expect(Invoice.count).to eq(2)
    #   expect(InvoiceItem.count).to eq(2)

    #   item_1.destroy_with_invoice_items_and_invoices

    #   expect(Invoice.count).to eq(2)
    #   expect(InvoiceItem.count).to eq(0)
    # end
  end

  describe "AR query methods" do
    it "finds items by name" do
      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item, name: "Computer Item", merchant_id: merchant.id)
      item_2 = FactoryBot.create(:item, name: "Turing Item", merchant_id: merchant.id)
      item_3 = FactoryBot.create(:item, name: "Ring World Item", merchant_id: merchant.id)

      expect(Item.find_items_by_name("ring")).to eq([item_3, item_2])
    end

    it "finds items by min and max price" do
      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item, unit_price: 3.99, merchant_id: merchant.id)
      item_2 = FactoryBot.create(:item, unit_price: 12.34, merchant_id: merchant.id)
      item_3 = FactoryBot.create(:item, unit_price: 100, merchant_id: merchant.id)

      expect(Item.find_items_by_min_and_max_price(4.99, 99.99)).to eq([item_2])
    end

    it "finds items by min price" do
      merchant = FactoryBot.create(:merchant)
      item_1 = Item.create!(name: "Computer Item", description: "fsfsadfs", unit_price: 49.00, merchant_id: merchant.id)
      item_2 = Item.create!(name: "Turing Item", description: "fsfsadfs", unit_price: 75.55, merchant_id: merchant.id)
      item_3 = Item.create!(name: "Ring World Item", description: "fsfsadfs", unit_price: 100, merchant_id: merchant.id)

      expect(Item.find_items_by_min_price(50)).to eq([item_3, item_2])
    end

    it "finds items by max price" do
      merchant = FactoryBot.create(:merchant)
      item_1 = Item.create!(name: "Computer Item", description: "fsfsadfs", unit_price: 49.00, merchant_id: merchant.id)
      item_2 = Item.create!(name: "Turing Item", description: "fsfsadfs", unit_price: 75.55, merchant_id: merchant.id)
      item_3 = Item.create!(name: "Ring World Item", description: "fsfsadfs", unit_price: 100, merchant_id: merchant.id)

      expect(Item.find_items_by_max_price(99.99)).to eq([item_1,item_2])
    end
  end
end