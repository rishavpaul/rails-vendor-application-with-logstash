class VendorSalesController < ApplicationController
  def create
    @vendor_sale = VendorSale.new(vendor_sale_params)

    if @vendor_sale.save
      render json: @vendor_sale, status: :created
    else
      render json: @vendor_sale.errors, status: :unprocessable_entity
    end
  end
  
  private
    def vendor_sale_params
      params.require(:vendor_sale).permit(:quantity, :vendor_item_id)
    end
end
