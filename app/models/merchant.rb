class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.find_merchant_by_name(name_fragment)
    Merchant.where("lower(name) LIKE ?", "%#{name_fragment.downcase}%")
    .order(:name)
    .first
  end
end