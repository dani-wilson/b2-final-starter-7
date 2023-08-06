require "rails_helper"

RSpec.describe "the bulk discounts show page" do 
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @discount_1 = @merchant1.bulk_discounts.create!(percentage_discount: 75, quantity_threshold: 20)

    @merchant2 = Merchant.create!(name: 'Jewelry')
    @discount_2 = @merchant2.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 5)
    @discount_3 = @merchant2.bulk_discounts.create!(percentage_discount: 25, quantity_threshold: 10)

    @merchant3 = Merchant.create!(name: 'Office Space')
    @discount_4 = @merchant3.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 40)

    @merchant4 = Merchant.create!(name: 'The Office')
    @discount_5 = @merchant4.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 10)

    @merchant5 = Merchant.create!(name: 'Office Improvement')
    @discount_6 = @merchant5.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 5)
    @discount_7 = @merchant5.bulk_discounts.create!(percentage_discount: 35, quantity_threshold: 35)

    @merchant6 = Merchant.create!(name: 'Pens & Stuff')
    @discount_8 = @merchant6.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 6)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)
  end
  # user story 4
  it "displays attributes of bulk discount" do
    visit merchant_discount_path(@merchant1, @discount_1.id)

    expect(page).to have_content(@discount_1.percentage_discount.round(0))
    expect(page).to have_content(@discount_1.quantity_threshold)
  end
  # user story 5
  it "displays a link to edit the bulk discount" do
    visit merchant_discount_path(@merchant1, @discount_1.id)

    expect(page).to have_link "Edit Discount"
  end

  it "when I click the link, I'm taken to a new page with a form to edit the discount" do
    visit merchant_discount_path(@merchant1, @discount_1.id)

    click_link "Edit Discount"

    expect(current_path).to eq(edit_merchant_discount_path(@merchant1, @discount_1.id))
  end

  it "I see the current discount attributes are pre-populated in the form" do
    visit edit_merchant_discount_path(@merchant1, @discount_1.id)

    expect(page).to have_field('Percentage discount', with: "75.0")
    expect(page).to have_field('Quantity threshold', with: "20")
  end

  it "when I change any/all of the form and hit submit, I am redirected to the discounts show page" do
    visit edit_merchant_discount_path(@merchant1, @discount_1.id)

    fill_in "Quantity threshold", with: "30"

    click_button "Update"

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1.id))
  end

  it "When I am redirected to the bulk discounts show page, I see the updated information" do
    visit edit_merchant_discount_path(@merchant1, @discount_1.id)

    fill_in "Quantity threshold", with: "30"

    click_button "Update"

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1.id))

    expect(page).to have_content("This discount offers 75% off with a purchase of 30 or more items.")
  end
end