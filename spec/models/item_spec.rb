require 'rails_helper'

RSpec.describe Item do
  describe "associations" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many :invoices }
  end

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