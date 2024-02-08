require 'rails_helper'

RSpec.describe InvoiceItem do
  describe "associations" do
    it { should belong_to :item }
    it { should belong_to :invoice }
  end
end