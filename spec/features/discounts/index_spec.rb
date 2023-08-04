require "rails_helper"

RSpec.describe "the discounts index page" do
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
  #user story 2
  it "displays a link to create a new discount" do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_link "Create a New Discount"
  end

  it "when I click the link, I'm taken to a new page where I see a form to add a new bulk discount" do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_link "Create a New Discount"

    click_link "Create a New Discount"

    expect(current_path).to eq(new_merchant_discount_path(@merchant1))
  end

  it "when I fill in the form with valid data, I am redirected back to the bulk discount index and I see my new bulk discount listed" do
    visit new_merchant_discount_path(@merchant1)

    fill_in "Percentage discount", with: "abc"
    fill_in "Quantity threshold", with: 10
    click_button "Submit"

    expect(page).to have_content("Invalid Data - Please Try Again")
    
    fill_in "Percentage discount", with: 50
    fill_in "Quantity threshold", with: "bananas"
    click_button "Submit"
    expect(page).to have_content("Invalid Data - Please Try Again")
    
    fill_in "Percentage discount", with: 10
    click_button "Submit"
    expect(page).to have_content("Invalid Data - Please Try Again")

    fill_in "Percentage discount", with: 10
    fill_in "Quantity threshold", with: 10
    click_button "Submit"
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_content("We have a 10% discount when you buy 10 or more items!")
  end
  # user story 3
  # As a merchant
  # When I visit my bulk discounts index
  # Then next to each bulk discount I see a link to delete it
  # When I click this link
  # Then I am redirected back to the bulk discounts index page
  # And I no longer see the discount listed
  it "displays a link to delete each bulk index" do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_link "Delete"
  end

  it "removes the discount upon clicking on the delete link" do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_link "Delete"

    click_link "Delete"
  end
end