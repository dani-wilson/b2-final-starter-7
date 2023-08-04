class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.new(new_discount_params)
    if @discount.save
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:notice] = "Invalid Data - Please Try Again"
      render :new
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.find(params[:id])
    @discount.destroy
    redirect_to merchant_discounts_path(@merchant)
  end

  private

  def new_discount_params
    params.permit(:percentage_discount, :quantity_threshold)
  end
end