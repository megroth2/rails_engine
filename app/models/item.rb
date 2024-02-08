class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def destroy_with_invoice_items_and_invoices
    invoices_items_to_destroy = Invoice.joins(:invoice_items)
                                  .where(invoice_items: { item_id: self.id })
                                  .group(:id)
                                  .having('COUNT(*) = 1')
  
    invoice_item_ids_to_destroy = invoices_items_to_destroy.pluck(:id)
  
    invoices_items_to_destroy.each do |invoice|
      invoice.invoice_items.destroy_all
      invoice.destroy
    end
    self.destroy
  end
end



