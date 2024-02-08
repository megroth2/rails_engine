require 'rails_helper'

RSpec.describe Merchant do
  describe "associations" do
    it { should have_many :items }
    it { should have_many :invoices }
  end
end