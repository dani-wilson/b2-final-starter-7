class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def best_discount
    BulkDiscount.where('quantity_threshold <= ?', quantity)
    .order(percentage_discount: :desc)
    .first
  end

  def invoice_item_total
    (quantity * unit_price).round(2)
  end

  def discounted_price
    dp = ((invoice_item_total * best_discount.percentify) - invoice_item_total).abs
    dp.round(2)
  end

  def total_item_revenue
    if best_discount.blank?
      invoice_item_total
    else
      discounted_price
    end
  end
end
