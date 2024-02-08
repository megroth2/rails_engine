require 'rails_helper'

RSpec.describe Invoice do
  describe "associations" do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many :items }
  end
end