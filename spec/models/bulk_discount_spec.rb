require 'rails_helper'

describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :percentage_discount }
    it { should validate_presence_of :quantity_threshold }
  end
  describe "relationships" do
    it { should belong_to :merchant }
  end
  describe "instance methods" do
    it "percentify" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @discount_1 = @merchant1.bulk_discounts.create!(percentage_discount: 75, quantity_threshold: 20)

      expect(@discount_1.percentify).to eq(0.75)
    end
  end
end