class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  # def initialize
  #   @merchants = merchants
  # end
end