BulkDiscount.destroy_all
InvoiceItem.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Item.destroy_all
Merchant.destroy_all
Customer.destroy_all

Rake::Task["csv_load:all"].invoke