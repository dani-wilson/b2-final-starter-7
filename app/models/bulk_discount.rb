class BulkDiscount < ApplicationRecord
  validates :percentage_discount, numericality: true, presence: true
  validates :quantity_threshold, length: {maximum: 2}, numericality: {only_integer: true}, presence: true

  belongs_to :merchant

  def percentify
    ((percentage_discount) / 100)
  end
end