class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def destroy_with_invoice_items_and_invoices
    invoices_to_destroy = Invoice.joins(:invoice_items)
                                  .where(invoice_items: { item_id: self.id })
                                  .group(:id)
                                  .having('COUNT(*) = 1')
  
    invoice_ids_to_destroy = invoices_to_destroy.pluck(:id)
  
    invoices_to_destroy.each do |invoice|
      invoice.invoice_items.destroy_all
      invoice.destroy
    end
    self.destroy
  end

  def self.find_items_by_name(name_fragment)
    Item.where("lower(name) LIKE ?", "%#{name_fragment.downcase}%")
    .order(:name)
  end

  def self.find_items_by_min_and_max_price(min_price, max_price)
    Item.where(unit_price: min_price.to_f..max_price.to_f)
    .order(:name)
  end

  def self.find_items_by_min_price(min_price)
    Item.where(unit_price >= min_price.to_f)
    .order(:name)
  end

  def self.find_items_by_max_price(max_price)
    Item.where(unit_price <= max_price.to_f)
    .order(:name)
  end
end



